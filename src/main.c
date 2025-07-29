/*
 * Copyright (c) 2016 Intel Corporation
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <zephyr/kernel.h>
#include <zephyr/drivers/gpio.h>
#include <zephyr/logging/log.h>
#include <zephyr/shell/shell.h>
#include <zephyr/sys/reboot.h>
#include <zephyr/bluetooth/bluetooth.h>
#include <zephyr/bluetooth/gap.h>
#include <zephyr/bluetooth/gatt.h>
#include <zephyr/bluetooth/uuid.h>

LOG_MODULE_REGISTER(main);

/* 1000 msec = 1 sec */
#define SLEEP_TIME_MS   1000

/* The devicetree node identifier for the "led0" alias. */
#define LED0_NODE DT_ALIAS(led0)

/*
 * A build error on this line means your board is unsupported.
 * See the sample documentation for information on how to fix this.
 */
static const struct gpio_dt_spec led = GPIO_DT_SPEC_GET(LED0_NODE, gpios);

/* Bluetooth advertising data */
static const struct bt_data ad[] = {
	BT_DATA_BYTES(BT_DATA_FLAGS, (BT_LE_AD_GENERAL | BT_LE_AD_NO_BREDR)),
	BT_DATA(BT_DATA_NAME_COMPLETE, CONFIG_BT_DEVICE_NAME, sizeof(CONFIG_BT_DEVICE_NAME) - 1),
};

/* Bluetooth scan response data (optional additional info) */
static const struct bt_data sd[] = {
	BT_DATA_BYTES(BT_DATA_UUID16_ALL, BT_UUID_16_ENCODE(BT_UUID_GATT_VAL)),
};

/* Bluetooth ready callback */
static void bt_ready_cb(int err)
{
	if (err) {
		LOG_ERR("Bluetooth init failed (err %d)", err);
		return;
	}

	LOG_INF("Bluetooth initialized");
	printk("Bluetooth initialized successfully\n");

	/* Start advertising */
	err = bt_le_adv_start(BT_LE_ADV_CONN_NAME, ad, ARRAY_SIZE(ad), sd, ARRAY_SIZE(sd));
	if (err) {
		LOG_ERR("Advertising failed to start (err %d)", err);
		printk("ERROR: Failed to start advertising! err = %d\n", err);
		return;
	}

	LOG_INF("Advertising successfully started");
	printk("Bluetooth advertising started as '%s'\n", CONFIG_BT_DEVICE_NAME);
}

/* Shell command to control LED */
static int cmd_led_on(const struct shell *shell, size_t argc, char **argv)
{
	ARG_UNUSED(argc);
	ARG_UNUSED(argv);
	
	gpio_pin_set_dt(&led, 1);
	shell_print(shell, "LED turned ON");
	return 0;
}

static int cmd_led_off(const struct shell *shell, size_t argc, char **argv)
{
	ARG_UNUSED(argc);
	ARG_UNUSED(argv);
	
	gpio_pin_set_dt(&led, 0);
	shell_print(shell, "LED turned OFF");
	return 0;
}

static int cmd_led_toggle(const struct shell *shell, size_t argc, char **argv)
{
	ARG_UNUSED(argc);
	ARG_UNUSED(argv);
	
	gpio_pin_toggle_dt(&led);
	shell_print(shell, "LED toggled");
	return 0;
}

static int cmd_dfu_mode(const struct shell *shell, size_t argc, char **argv)
{
	ARG_UNUSED(argc);
	ARG_UNUSED(argv);
	
	shell_print(shell, "Entering DFU mode...");
	shell_print(shell, "Device will reboot into bootloader for USB flashing");
	k_msleep(100); // Give time for message to be sent
	
	/* Reboot into DFU mode */
	// sys_reboot(SYS_REBOOT_COLD);
	
	return 0;
}

static int cmd_bt_start_adv(const struct shell *shell, size_t argc, char **argv)
{
	ARG_UNUSED(argc);
	ARG_UNUSED(argv);
	
	int err = bt_le_adv_start(BT_LE_ADV_CONN_NAME, ad, ARRAY_SIZE(ad), sd, ARRAY_SIZE(sd));
	if (err) {
		shell_print(shell, "Failed to start advertising (err %d)", err);
	} else {
		shell_print(shell, "Advertising started as '%s'", CONFIG_BT_DEVICE_NAME);
	}
	return 0;
}

static int cmd_bt_stop_adv(const struct shell *shell, size_t argc, char **argv)
{
	ARG_UNUSED(argc);
	ARG_UNUSED(argv);
	
	int err = bt_le_adv_stop();
	if (err) {
		shell_print(shell, "Failed to stop advertising (err %d)", err);
	} else {
		shell_print(shell, "Advertising stopped");
	}
	return 0;
}

SHELL_STATIC_SUBCMD_SET_CREATE(sub_led,
	SHELL_CMD(on, NULL, "Turn LED on", cmd_led_on),
	SHELL_CMD(off, NULL, "Turn LED off", cmd_led_off),
	SHELL_CMD(toggle, NULL, "Toggle LED", cmd_led_toggle),
	SHELL_SUBCMD_SET_END /* Array terminated. */
);

// SHELL_STATIC_SUBCMD_SET_CREATE(sub_bt,
//     SHELL_CMD(start, NULL, "Start advertising", cmd_bt_start_adv),
//     SHELL_CMD(stop, NULL, "Stop advertising", cmd_bt_stop_adv),
//     SHELL_SUBCMD_SET_END /* Array terminated. */
// );

SHELL_CMD_REGISTER(led, &sub_led, "LED commands", NULL);
// SHELL_CMD_REGISTER(bt, &sub_bt, "Bluetooth commands", NULL);
SHELL_CMD_REGISTER(dfu, NULL, "Enter DFU mode for USB flashing", cmd_dfu_mode);

int main(void)
{
	int ret;

	printk("=== nRF52840 Blinky Application Starting ===\n");

	if (!gpio_is_ready_dt(&led)) {
		LOG_ERR("Error: the LED devicetree node is not ready");
		printk("ERROR: LED devicetree node not ready!\n");
		return 0;
	}

	printk("LED GPIO is ready\n");

	ret = gpio_pin_configure_dt(&led, GPIO_OUTPUT_ACTIVE);
	if (ret < 0) {
		LOG_ERR("Error %d: failed to configure the LED pin", ret);
		printk("ERROR: Failed to configure LED pin! ret = %d\n", ret);
		return 0;
	}

	printk("LED pin configured successfully\n");

	/* Initialize Bluetooth */
	ret = bt_enable(bt_ready_cb);
	if (ret) {
		LOG_ERR("Bluetooth init failed (err %d)", ret);
		printk("ERROR: Bluetooth initialization failed! ret = %d\n", ret);
	} else {
		printk("Bluetooth initialization started...\n");
	}

	LOG_INF("LED blink example started");
	printk("Hello from nRF52840! LED blink starting...\n");

	while (1) {
		ret = gpio_pin_toggle_dt(&led);
		if (ret < 0) {
			LOG_ERR("Error %d: failed to toggle LED", ret);
			printk("ERROR: Failed to toggle LED! ret = %d\n", ret);
			return 0;
		}
		
		// LOG_INF("LED toggled");
		// printk("LED toggled\n");
		k_msleep(SLEEP_TIME_MS);
	}
	
	return 0;
}
