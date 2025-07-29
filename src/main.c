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
#include <zephyr/bluetooth/gatt.h>
#include <zephyr/bluetooth/uuid.h>

LOG_MODULE_REGISTER(main);

/* Bluetooth LE Data Streaming */
#ifdef CONFIG_BT

/* Custom service UUID: using simpler 16-bit UUID */
#define BT_UUID_CUSTOM_SERVICE_VAL 0x1234
#define BT_UUID_CUSTOM_SERVICE BT_UUID_DECLARE_16(BT_UUID_CUSTOM_SERVICE_VAL)

/* Custom characteristic UUID for data streaming */
#define BT_UUID_CUSTOM_DATA_VAL 0x1235
#define BT_UUID_CUSTOM_DATA BT_UUID_DECLARE_16(BT_UUID_CUSTOM_DATA_VAL)

static struct bt_conn *current_conn = NULL;

/* GATT service definition */
static ssize_t read_data(struct bt_conn *conn, const struct bt_gatt_attr *attr,
                        void *buf, uint16_t len, uint16_t offset)
{
    const char *data = "Hello from nRF52840!";
    return bt_gatt_attr_read(conn, attr, buf, len, offset, data, strlen(data));
}

static ssize_t write_data(struct bt_conn *conn, const struct bt_gatt_attr *attr,
                         const void *buf, uint16_t len, uint16_t offset, uint8_t flags)
{
    LOG_INF("Received %d bytes via BLE", len);
    return len;
}

BT_GATT_SERVICE_DEFINE(data_svc,
    BT_GATT_PRIMARY_SERVICE(BT_UUID_CUSTOM_SERVICE),
    BT_GATT_CHARACTERISTIC(BT_UUID_CUSTOM_DATA,
                          BT_GATT_CHRC_READ | BT_GATT_CHRC_WRITE | BT_GATT_CHRC_NOTIFY,
                          BT_GATT_PERM_READ | BT_GATT_PERM_WRITE,
                          read_data, write_data, NULL),
    BT_GATT_CCC(NULL, BT_GATT_PERM_READ | BT_GATT_PERM_WRITE),
);

static void connected(struct bt_conn *conn, uint8_t err)
{
    if (err) {
        LOG_ERR("Connection failed (err %u)", err);
        return;
    }
    
    current_conn = bt_conn_ref(conn);
    LOG_INF("BLE Connected");
    printk("BLE device connected!\n");
}

static void disconnected(struct bt_conn *conn, uint8_t reason)
{
    if (current_conn) {
        bt_conn_unref(current_conn);
        current_conn = NULL;
    }
    LOG_INF("BLE Disconnected (reason %u)", reason);
    printk("BLE device disconnected!\n");
}

BT_CONN_CB_DEFINE(conn_callbacks) = {
    .connected = connected,
    .disconnected = disconnected,
};

static const struct bt_data ad[] = {
    BT_DATA_BYTES(BT_DATA_FLAGS, (BT_LE_AD_GENERAL | BT_LE_AD_NO_BREDR)),
    BT_DATA_BYTES(BT_DATA_UUID16_ALL, 0x34, 0x12), /* Little endian UUID */
};

static const struct bt_data sd[] = {
    BT_DATA(BT_DATA_NAME_COMPLETE, "Zephyr Data Streamer", sizeof("Zephyr Data Streamer") - 1),
};

void stream_data(uint8_t *data, size_t len)
{
    if (!current_conn) {
        LOG_WRN("No BLE connection");
        printk("No BLE connection for streaming\n");
        return;
    }

    const struct bt_gatt_attr *attr = &data_svc.attrs[2]; // Data characteristic
    
    int err = bt_gatt_notify(current_conn, attr, data, len);
    if (err) {
        LOG_ERR("Failed to send notification (err %d)", err);
        printk("Failed to stream data (err %d)\n", err);
    } else {
        LOG_INF("Streamed %d bytes via BLE", len);
        printk("Streamed %d bytes via BLE\n", len);
    }
}

void data_streaming_init(void)
{
    int err;

    err = bt_enable(NULL);
    if (err) {
        LOG_ERR("Bluetooth init failed (err %d)", err);
        printk("Bluetooth init failed (err %d)\n", err);
        return;
    }

    err = bt_le_adv_start(BT_LE_ADV_CONN_NAME, ad, ARRAY_SIZE(ad), sd, ARRAY_SIZE(sd));
    if (err) {
        LOG_ERR("Advertising failed to start (err %d)", err);
        printk("Advertising failed to start (err %d)\n", err);
        return;
    }

    LOG_INF("BLE advertising started");
    printk("BLE advertising started - device discoverable as 'Zephyr Data Streamer'\n");
}

#else
/* Dummy functions when Bluetooth is not enabled */
void stream_data(uint8_t *data, size_t len)
{
    printk("BLE not enabled - would stream %d bytes\n", len);
}

void data_streaming_init(void)
{
    printk("BLE not enabled\n");
}
#endif

/* 1000 msec = 1 sec */
#define SLEEP_TIME_MS   1000

/* The devicetree node identifier for the "led0" alias. */
#define LED0_NODE DT_ALIAS(led0)

/*
 * A build error on this line means your board is unsupported.
 * See the sample documentation for information on how to fix this.
 */
static const struct gpio_dt_spec led = GPIO_DT_SPEC_GET(LED0_NODE, gpios);

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
	sys_reboot(SYS_REBOOT_COLD);
	
	return 0;
}

static int cmd_stream_test(const struct shell *shell, size_t argc, char **argv)
{
	ARG_UNUSED(argc);
	ARG_UNUSED(argv);
	
	uint8_t test_data[] = "Hello from nRF52840! This is a streaming test.";
	stream_data(test_data, sizeof(test_data) - 1); // -1 to exclude null terminator
	shell_print(shell, "Test data streamed");
	return 0;
}

SHELL_STATIC_SUBCMD_SET_CREATE(sub_led,
	SHELL_CMD(on, NULL, "Turn LED on", cmd_led_on),
	SHELL_CMD(off, NULL, "Turn LED off", cmd_led_off),
	SHELL_CMD(toggle, NULL, "Toggle LED", cmd_led_toggle),
	SHELL_SUBCMD_SET_END /* Array terminated. */
);
SHELL_CMD_REGISTER(led, &sub_led, "LED commands", NULL);
SHELL_CMD_REGISTER(dfu, NULL, "Enter DFU mode for USB flashing", cmd_dfu_mode);
SHELL_CMD_REGISTER(stream, NULL, "Test data streaming", cmd_stream_test);

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

	/* Initialize data streaming */
	data_streaming_init();
	printk("Data streaming initialized\n");

	LOG_INF("LED blink example started");
	printk("Hello from nRF52840! LED blink starting...\n");

	while (1) {
		ret = gpio_pin_toggle_dt(&led);
		if (ret < 0) {
			LOG_ERR("Error %d: failed to toggle LED", ret);
			printk("ERROR: Failed to toggle LED! ret = %d\n", ret);
			return 0;
		}
		
		LOG_INF("LED toggled");
		printk("LED toggled\n");
		k_msleep(SLEEP_TIME_MS);
	}
	
	return 0;
}
