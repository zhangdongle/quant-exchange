/*
 Navicat Premium Data Transfer

 Source Server         : 127.0.0.1
 Source Server Type    : MySQL
 Source Server Version : 50725
 Source Host           : localhost:3306
 Source Schema         : quant

 Target Server Type    : MySQL
 Target Server Version : 50725
 File Encoding         : 65001

 Date: 17/03/2021 18:42:31
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for account
-- ----------------------------
DROP TABLE IF EXISTS `account`;
CREATE TABLE `account`  (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `user_id` int(8) NOT NULL,
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `access_key` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `secret_key` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `type` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `state` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `info` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `is_delete` tinyint(1) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10477421 CHARACTER SET = utf8 COLLATE = utf8_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of account
-- ----------------------------
INSERT INTO `account` VALUES (10477420, 1, 'LJL', 'c57b31d5-dd005b54-42ef1a35-7yngd7gh5g', '45f580d4-931e90f5-f32f98f8-6835f', 'spot', 'working', '', '2021-03-04 15:37:00', NULL);

-- ----------------------------
-- Table structure for balance
-- ----------------------------
DROP TABLE IF EXISTS `balance`;
CREATE TABLE `balance`  (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `account_id` int(8) NOT NULL,
  `type` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `currency` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `trade_balance` varchar(30) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `frozen_balance` varchar(30) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for order_profit
-- ----------------------------
DROP TABLE IF EXISTS `order_profit`;
CREATE TABLE `order_profit`  (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `robot_id` int(8) NOT NULL,
  `sell_order_id` int(8) NULL DEFAULT NULL,
  `buy_order_id` int(8) NULL DEFAULT NULL,
  `buy_price` decimal(30, 10) NULL DEFAULT NULL,
  `sell_price` decimal(30, 10) NULL DEFAULT NULL,
  `buy_cash_amount` decimal(30, 10) NULL DEFAULT NULL,
  `sell_cash_amount` decimal(30, 10) NULL DEFAULT NULL,
  `buy_amount` decimal(30, 10) NULL DEFAULT NULL,
  `sell_amount` decimal(30, 10) NULL DEFAULT NULL,
  `is_profit` tinyint(1) NULL DEFAULT NULL,
  `diff` decimal(30, 10) NULL DEFAULT NULL,
  `divide` decimal(30, 10) NULL DEFAULT NULL,
  `create_time` timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `order_id` int(8) NOT NULL,
  `symbol` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `robot_id` int(8) NOT NULL,
  `account_id` int(8) NOT NULL,
  `amount` decimal(30, 10) NOT NULL,
  `price` decimal(30, 10) NOT NULL,
  `order_state` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `order_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `create_time` bigint(20) NOT NULL,
  `finished_time` bigint(20) NOT NULL,
  `field_fees` decimal(30, 10) NOT NULL,
  `field_amount` decimal(30, 10) NOT NULL,
  `field_cash_amount` decimal(30, 10) NOT NULL,
  PRIMARY KEY (`order_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for robot
-- ----------------------------
DROP TABLE IF EXISTS `robot`;
CREATE TABLE `robot`  (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `robot_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `symbol` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `user_id` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `account_id` int(8) NOT NULL,
  `strategy_id` int(8) NOT NULL,
  `client_address` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `is_run` tinyint(1) NOT NULL DEFAULT 0,
  `create_time` timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `is_delete` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of robot
-- ----------------------------
INSERT INTO `robot` VALUES (1, '小Q', 'daihusd', '1', 10477420, 1, '0.0.0.0:8024', 0, '2021-03-04 15:45:33.089', 0);
INSERT INTO `robot` VALUES (2, 'l', 'daihusd', '1', 10477420, 2, '0.0.0.0:8024', 0, '2021-03-04 16:53:06.351', 0);

-- ----------------------------
-- Table structure for strategy
-- ----------------------------
DROP TABLE IF EXISTS `strategy`;
CREATE TABLE `strategy`  (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `user_id` int(8) NULL DEFAULT NULL,
  `strategy_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `strategy_type` int(2) NULL DEFAULT NULL,
  `buy_amount` decimal(30, 10) NULL DEFAULT NULL,
  `buy_quota_price` decimal(30, 10) NULL DEFAULT NULL,
  `sell_amount` decimal(30, 10) NULL DEFAULT NULL,
  `buy_price` decimal(30, 10) NULL DEFAULT NULL,
  `sell_price` decimal(30, 10) NULL DEFAULT NULL,
  `is_all_buy` tinyint(1) NULL DEFAULT NULL,
  `is_all_sell` tinyint(1) NULL DEFAULT NULL,
  `is_limit_price` tinyint(1) NULL DEFAULT NULL,
  `sell_all_weights` int(3) NULL DEFAULT NULL,
  `buy_all_weights` int(3) NULL DEFAULT NULL,
  `profit` int(8) NULL DEFAULT NULL,
  `sleep` double(10, 0) NULL DEFAULT NULL,
  `setting1` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `setting2` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `setting3` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `setting4` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `setting5` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `setting6` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of strategy
-- ----------------------------
INSERT INTO `strategy` VALUES (1, 1, '稳定币低买高卖', 0, NULL, NULL, NULL, 1.0047000000, 0.9999000000, 1, 1, 1, 1, 1, 1, 3, '{\"buyOrdersUsdt\":0,\"buyWeights\":0,\"sellOrdersUsdt\":0,\"sellWeights\":0}', '{\"buyOrderUsdt\":0,\"buyWeights\":0,\"sellOrderUsdt\":0,\"sellWeights\":0}', '{\"buyDownPercent\":0.0,\"buyDownSecond\":1,\"buyWeights\":0,\"sellDownPercent\":0.0,\"sellDownSecond\":1,\"sellWeights\":0}', '{\"buyUpPercent\":0.0,\"buyUpSecond\":1,\"buyWeights\":0,\"sellUpPercent\":0.0,\"sellUpSecond\":1,\"sellWeights\":0}', '{\"buyStrategy\":[{\"buyKline\":\"1min\",\"buyKlineOption\":\"1\",\"buyPercent\":\"\",\"buyWeights\":0,\"id\":1}],\"sellStrategy\":[{\"id\":1,\"sellKline\":\"1min\",\"sellKlineOption\":\"1\",\"sellPercent\":\"\",\"sellWeights\":0}]}', '{\"isAble\":0,\"stopLoss\":0,\"takeProfit\":0}');
INSERT INTO `strategy` VALUES (2, 1, 'l', 0, 0.0000000000, 5.0000000000, 5.0000000000, 0.9975000000, 1.0025000000, 1, 1, 1, 10, 10, 1, 3, '{\"buyOrdersUsdt\":0.9995,\"buyWeights\":50,\"sellOrdersUsdt\":0.9996,\"sellWeights\":50}', '{\"buyOrderUsdt\":0.9996,\"buyWeights\":10,\"sellOrderUsdt\":0.9996,\"sellWeights\":10}', '{\"buyDownPercent\":10.0,\"buyDownSecond\":1,\"buyWeights\":10,\"sellDownPercent\":10.0,\"sellDownSecond\":1,\"sellWeights\":10}', '{\"buyUpPercent\":10.0,\"buyUpSecond\":1,\"buyWeights\":5,\"sellUpPercent\":10.0,\"sellUpSecond\":1,\"sellWeights\":5}', '{\"buyStrategy\":[{\"buyKline\":\"1min\",\"buyKlineOption\":\"1\",\"buyPercent\":\"10\",\"buyWeights\":10,\"id\":1}],\"sellStrategy\":[{\"id\":1,\"sellKline\":\"1min\",\"sellKlineOption\":\"1\",\"sellPercent\":\"10\",\"sellWeights\":10}]}', '{\"isAble\":1,\"stopLoss\":10,\"takeProfit\":10}');

-- ----------------------------
-- Table structure for symbol
-- ----------------------------
DROP TABLE IF EXISTS `symbol`;
CREATE TABLE `symbol`  (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `base_currency` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `quote_currency` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `price_precision` int(8) NOT NULL,
  `amount_precision` int(8) NULL DEFAULT NULL,
  `symbol` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 916 CHARACTER SET = utf8 COLLATE = utf8_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of symbol
-- ----------------------------
INSERT INTO `symbol` VALUES (1, '18c', 'btc', 10, 2, '18cbtc');
INSERT INTO `symbol` VALUES (2, '18c', 'eth', 8, 2, '18ceth');
INSERT INTO `symbol` VALUES (3, '1inch', 'btc', 8, 2, '1inchbtc');
INSERT INTO `symbol` VALUES (4, '1inch', 'eth', 8, 2, '1incheth');
INSERT INTO `symbol` VALUES (5, '1inch', 'usdt', 6, 4, '1inchusdt');
INSERT INTO `symbol` VALUES (6, 'aac', 'btc', 10, 2, 'aacbtc');
INSERT INTO `symbol` VALUES (7, 'aac', 'eth', 8, 2, 'aaceth');
INSERT INTO `symbol` VALUES (8, 'aac', 'usdt', 6, 2, 'aacusdt');
INSERT INTO `symbol` VALUES (9, 'aave', 'btc', 6, 4, 'aavebtc');
INSERT INTO `symbol` VALUES (10, 'aave', 'eth', 4, 4, 'aaveeth');
INSERT INTO `symbol` VALUES (11, 'aave', 'husd', 4, 4, 'aavehusd');
INSERT INTO `symbol` VALUES (12, 'aave', 'usdt', 4, 4, 'aaveusdt');
INSERT INTO `symbol` VALUES (13, 'abt', 'btc', 8, 2, 'abtbtc');
INSERT INTO `symbol` VALUES (14, 'abt', 'eth', 8, 2, 'abteth');
INSERT INTO `symbol` VALUES (15, 'abt', 'usdt', 4, 2, 'abtusdt');
INSERT INTO `symbol` VALUES (16, 'ach', 'btc', 10, 2, 'achbtc');
INSERT INTO `symbol` VALUES (17, 'ach', 'eth', 8, 2, 'acheth');
INSERT INTO `symbol` VALUES (18, 'ach', 'usdt', 6, 4, 'achusdt');
INSERT INTO `symbol` VALUES (19, 'act', 'btc', 10, 2, 'actbtc');
INSERT INTO `symbol` VALUES (20, 'act', 'eth', 8, 2, 'acteth');
INSERT INTO `symbol` VALUES (21, 'act', 'usdt', 6, 2, 'actusdt');
INSERT INTO `symbol` VALUES (22, 'ada', 'btc', 8, 2, 'adabtc');
INSERT INTO `symbol` VALUES (23, 'ada', 'eth', 6, 4, 'adaeth');
INSERT INTO `symbol` VALUES (24, 'ada', 'husd', 6, 4, 'adahusd');
INSERT INTO `symbol` VALUES (25, 'ada', 'usdt', 6, 4, 'adausdt');
INSERT INTO `symbol` VALUES (26, 'adx', 'btc', 8, 2, 'adxbtc');
INSERT INTO `symbol` VALUES (27, 'adx', 'eth', 10, 2, 'adxeth');
INSERT INTO `symbol` VALUES (28, 'ae', 'btc', 8, 2, 'aebtc');
INSERT INTO `symbol` VALUES (29, 'ae', 'eth', 6, 4, 'aeeth');
INSERT INTO `symbol` VALUES (30, 'ae', 'usdt', 4, 2, 'aeusdt');
INSERT INTO `symbol` VALUES (31, 'aidoc', 'btc', 10, 2, 'aidocbtc');
INSERT INTO `symbol` VALUES (32, 'aidoc', 'eth', 8, 2, 'aidoceth');
INSERT INTO `symbol` VALUES (33, 'akro', 'btc', 10, 2, 'akrobtc');
INSERT INTO `symbol` VALUES (34, 'akro', 'ht', 6, 2, 'akroht');
INSERT INTO `symbol` VALUES (35, 'akro', 'husd', 6, 4, 'akrohusd');
INSERT INTO `symbol` VALUES (36, 'akro', 'usdt', 5, 2, 'akrousdt');
INSERT INTO `symbol` VALUES (37, 'algo', 'btc', 8, 2, 'algobtc');
INSERT INTO `symbol` VALUES (38, 'algo', 'eth', 6, 4, 'algoeth');
INSERT INTO `symbol` VALUES (39, 'algo', 'husd', 4, 4, 'algohusd');
INSERT INTO `symbol` VALUES (40, 'algo', 'usdt', 4, 2, 'algousdt');
INSERT INTO `symbol` VALUES (41, 'ankr', 'btc', 10, 2, 'ankrbtc');
INSERT INTO `symbol` VALUES (42, 'ankr', 'ht', 6, 2, 'ankrht');
INSERT INTO `symbol` VALUES (43, 'ankr', 'usdt', 6, 2, 'ankrusdt');
INSERT INTO `symbol` VALUES (44, 'ant', 'btc', 8, 2, 'antbtc');
INSERT INTO `symbol` VALUES (45, 'ant', 'eth', 6, 2, 'anteth');
INSERT INTO `symbol` VALUES (46, 'ant', 'usdt', 4, 2, 'antusdt');
INSERT INTO `symbol` VALUES (47, 'api3', 'btc', 8, 2, 'api3btc');
INSERT INTO `symbol` VALUES (48, 'api3', 'eth', 6, 4, 'api3eth');
INSERT INTO `symbol` VALUES (49, 'api3', 'usdt', 4, 4, 'api3usdt');
INSERT INTO `symbol` VALUES (50, 'appc', 'btc', 8, 2, 'appcbtc');
INSERT INTO `symbol` VALUES (51, 'appc', 'eth', 6, 4, 'appceth');
INSERT INTO `symbol` VALUES (52, 'ar', 'btc', 8, 2, 'arbtc');
INSERT INTO `symbol` VALUES (53, 'ardr', 'btc', 8, 2, 'ardrbtc');
INSERT INTO `symbol` VALUES (54, 'ardr', 'eth', 6, 4, 'ardreth');
INSERT INTO `symbol` VALUES (55, 'ar', 'eth', 6, 2, 'areth');
INSERT INTO `symbol` VALUES (56, 'arpa', 'btc', 8, 2, 'arpabtc');
INSERT INTO `symbol` VALUES (57, 'arpa', 'ht', 6, 2, 'arpaht');
INSERT INTO `symbol` VALUES (58, 'arpa', 'usdt', 6, 2, 'arpausdt');
INSERT INTO `symbol` VALUES (59, 'ar', 'usdt', 4, 2, 'arusdt');
INSERT INTO `symbol` VALUES (60, 'ast', 'btc', 8, 0, 'astbtc');
INSERT INTO `symbol` VALUES (61, 'ast', 'eth', 8, 2, 'asteth');
INSERT INTO `symbol` VALUES (62, 'ast', 'usdt', 4, 4, 'astusdt');
INSERT INTO `symbol` VALUES (63, 'atom', 'btc', 8, 2, 'atombtc');
INSERT INTO `symbol` VALUES (64, 'atom', 'eth', 6, 4, 'atometh');
INSERT INTO `symbol` VALUES (65, 'atom', 'usdt', 4, 2, 'atomusdt');
INSERT INTO `symbol` VALUES (66, 'atp', 'btc', 10, 2, 'atpbtc');
INSERT INTO `symbol` VALUES (67, 'atp', 'ht', 6, 2, 'atpht');
INSERT INTO `symbol` VALUES (68, 'atp', 'usdt', 5, 2, 'atpusdt');
INSERT INTO `symbol` VALUES (69, 'auction', 'btc', 8, 4, 'auctionbtc');
INSERT INTO `symbol` VALUES (70, 'auction', 'eth', 6, 4, 'auctioneth');
INSERT INTO `symbol` VALUES (71, 'auction', 'usdt', 4, 4, 'auctionusdt');
INSERT INTO `symbol` VALUES (72, 'avax', 'btc', 8, 4, 'avaxbtc');
INSERT INTO `symbol` VALUES (73, 'avax', 'eth', 6, 4, 'avaxeth');
INSERT INTO `symbol` VALUES (74, 'avax', 'usdt', 4, 4, 'avaxusdt');
INSERT INTO `symbol` VALUES (75, 'badger', 'btc', 8, 2, 'badgerbtc');
INSERT INTO `symbol` VALUES (76, 'badger', 'eth', 6, 4, 'badgereth');
INSERT INTO `symbol` VALUES (77, 'badger', 'usdt', 4, 4, 'badgerusdt');
INSERT INTO `symbol` VALUES (78, 'bags', 'usdt', 4, 4, 'bagsusdt');
INSERT INTO `symbol` VALUES (79, 'bal', 'btc', 8, 2, 'balbtc');
INSERT INTO `symbol` VALUES (80, 'bal', 'eth', 6, 2, 'baleth');
INSERT INTO `symbol` VALUES (81, 'bal', 'husd', 4, 2, 'balhusd');
INSERT INTO `symbol` VALUES (82, 'bal', 'usdt', 4, 2, 'balusdt');
INSERT INTO `symbol` VALUES (83, 'band', 'btc', 8, 2, 'bandbtc');
INSERT INTO `symbol` VALUES (84, 'band', 'eth', 6, 2, 'bandeth');
INSERT INTO `symbol` VALUES (85, 'band', 'husd', 4, 2, 'bandhusd');
INSERT INTO `symbol` VALUES (86, 'band', 'usdt', 4, 2, 'bandusdt');
INSERT INTO `symbol` VALUES (87, 'bat', 'btc', 8, 0, 'batbtc');
INSERT INTO `symbol` VALUES (88, 'bat', 'eth', 8, 0, 'bateth');
INSERT INTO `symbol` VALUES (89, 'bat', 'usdt', 4, 2, 'batusdt');
INSERT INTO `symbol` VALUES (90, 'bcd', 'btc', 7, 4, 'bcdbtc');
INSERT INTO `symbol` VALUES (91, 'bch3l', 'usdt', 4, 4, 'bch3lusdt');
INSERT INTO `symbol` VALUES (92, 'bch3s', 'usdt', 6, 4, 'bch3susdt');
INSERT INTO `symbol` VALUES (93, 'bcha', 'btc', 6, 4, 'bchabtc');
INSERT INTO `symbol` VALUES (94, 'bcha', 'usdt', 4, 4, 'bchausdt');
INSERT INTO `symbol` VALUES (95, 'bch', 'btc', 6, 4, 'bchbtc');
INSERT INTO `symbol` VALUES (96, 'bch', 'ht', 6, 4, 'bchht');
INSERT INTO `symbol` VALUES (97, 'bch', 'husd', 2, 4, 'bchhusd');
INSERT INTO `symbol` VALUES (98, 'bch', 'usdt', 2, 4, 'bchusdt');
INSERT INTO `symbol` VALUES (99, 'bcv', 'btc', 10, 2, 'bcvbtc');
INSERT INTO `symbol` VALUES (100, 'bcv', 'eth', 8, 2, 'bcveth');
INSERT INTO `symbol` VALUES (101, 'bcx', 'btc', 10, 4, 'bcxbtc');
INSERT INTO `symbol` VALUES (102, 'beth', 'eth', 4, 4, 'betheth');
INSERT INTO `symbol` VALUES (103, 'beth', 'usdt', 2, 6, 'bethusdt');
INSERT INTO `symbol` VALUES (104, 'bft', 'btc', 10, 2, 'bftbtc');
INSERT INTO `symbol` VALUES (105, 'bft', 'eth', 8, 4, 'bfteth');
INSERT INTO `symbol` VALUES (106, 'bhd', 'btc', 6, 4, 'bhdbtc');
INSERT INTO `symbol` VALUES (107, 'bhd', 'ht', 4, 4, 'bhdht');
INSERT INTO `symbol` VALUES (108, 'bhd', 'usdt', 4, 4, 'bhdusdt');
INSERT INTO `symbol` VALUES (109, 'bifi', 'btc', 10, 4, 'bifibtc');
INSERT INTO `symbol` VALUES (110, 'bix', 'btc', 8, 2, 'bixbtc');
INSERT INTO `symbol` VALUES (111, 'bix', 'eth', 6, 4, 'bixeth');
INSERT INTO `symbol` VALUES (112, 'bix', 'usdt', 6, 4, 'bixusdt');
INSERT INTO `symbol` VALUES (113, 'bkbt', 'btc', 10, 2, 'bkbtbtc');
INSERT INTO `symbol` VALUES (114, 'bkbt', 'eth', 8, 2, 'bkbteth');
INSERT INTO `symbol` VALUES (115, 'blz', 'btc', 8, 2, 'blzbtc');
INSERT INTO `symbol` VALUES (116, 'blz', 'eth', 8, 2, 'blzeth');
INSERT INTO `symbol` VALUES (117, 'blz', 'usdt', 4, 2, 'blzusdt');
INSERT INTO `symbol` VALUES (118, 'bnt', 'btc', 8, 2, 'bntbtc');
INSERT INTO `symbol` VALUES (119, 'bnt', 'eth', 6, 2, 'bnteth');
INSERT INTO `symbol` VALUES (120, 'bnt', 'usdt', 4, 2, 'bntusdt');
INSERT INTO `symbol` VALUES (121, 'bor', 'btc', 6, 4, 'borbtc');
INSERT INTO `symbol` VALUES (122, 'bor', 'eth', 4, 4, 'boreth');
INSERT INTO `symbol` VALUES (123, 'bor', 'usdt', 2, 6, 'borusdt');
INSERT INTO `symbol` VALUES (124, 'bot', 'btc', 6, 4, 'botbtc');
INSERT INTO `symbol` VALUES (125, 'bot', 'eth', 4, 4, 'boteth');
INSERT INTO `symbol` VALUES (126, 'bot', 'usdt', 2, 6, 'botusdt');
INSERT INTO `symbol` VALUES (127, 'box', 'btc', 10, 2, 'boxbtc');
INSERT INTO `symbol` VALUES (128, 'box', 'eth', 8, 2, 'boxeth');
INSERT INTO `symbol` VALUES (129, 'bsv3l', 'usdt', 4, 4, 'bsv3lusdt');
INSERT INTO `symbol` VALUES (130, 'bsv3s', 'usdt', 6, 4, 'bsv3susdt');
INSERT INTO `symbol` VALUES (131, 'bsv', 'btc', 6, 4, 'bsvbtc');
INSERT INTO `symbol` VALUES (132, 'bsv', 'husd', 4, 4, 'bsvhusd');
INSERT INTO `symbol` VALUES (133, 'bsv', 'usdt', 4, 4, 'bsvusdt');
INSERT INTO `symbol` VALUES (134, 'bt1', 'btc', 6, 4, 'bt1btc');
INSERT INTO `symbol` VALUES (135, 'bt2', 'btc', 6, 4, 'bt2btc');
INSERT INTO `symbol` VALUES (136, 'btc1s', 'usdt', 4, 4, 'btc1susdt');
INSERT INTO `symbol` VALUES (137, 'btc3l', 'usdt', 4, 4, 'btc3lusdt');
INSERT INTO `symbol` VALUES (138, 'btc3s', 'usdt', 6, 4, 'btc3susdt');
INSERT INTO `symbol` VALUES (139, 'btc', 'husd', 2, 6, 'btchusd');
INSERT INTO `symbol` VALUES (140, 'btc', 'usdt', 2, 6, 'btcusdt');
INSERT INTO `symbol` VALUES (141, 'btg', 'btc', 6, 4, 'btgbtc');
INSERT INTO `symbol` VALUES (142, 'btm', 'btc', 8, 2, 'btmbtc');
INSERT INTO `symbol` VALUES (143, 'btm', 'eth', 8, 2, 'btmeth');
INSERT INTO `symbol` VALUES (144, 'btm', 'husd', 6, 4, 'btmhusd');
INSERT INTO `symbol` VALUES (145, 'btm', 'usdt', 4, 2, 'btmusdt');
INSERT INTO `symbol` VALUES (146, 'bts', 'btc', 8, 2, 'btsbtc');
INSERT INTO `symbol` VALUES (147, 'bts', 'eth', 8, 2, 'btseth');
INSERT INTO `symbol` VALUES (148, 'bts', 'usdt', 4, 2, 'btsusdt');
INSERT INTO `symbol` VALUES (149, 'btt', 'btc', 10, 2, 'bttbtc');
INSERT INTO `symbol` VALUES (150, 'btt', 'eth', 10, 2, 'btteth');
INSERT INTO `symbol` VALUES (151, 'btt', 'trx', 6, 4, 'btttrx');
INSERT INTO `symbol` VALUES (152, 'btt', 'usdt', 8, 0, 'bttusdt');
INSERT INTO `symbol` VALUES (153, 'but', 'btc', 10, 2, 'butbtc');
INSERT INTO `symbol` VALUES (154, 'but', 'eth', 8, 2, 'buteth');
INSERT INTO `symbol` VALUES (155, 'cdc', 'btc', 10, 2, 'cdcbtc');
INSERT INTO `symbol` VALUES (156, 'cdc', 'eth', 8, 2, 'cdceth');
INSERT INTO `symbol` VALUES (157, 'chat', 'btc', 10, 2, 'chatbtc');
INSERT INTO `symbol` VALUES (158, 'chat', 'eth', 8, 2, 'chateth');
INSERT INTO `symbol` VALUES (159, 'chr', 'btc', 8, 2, 'chrbtc');
INSERT INTO `symbol` VALUES (160, 'chr', 'ht', 6, 2, 'chrht');
INSERT INTO `symbol` VALUES (161, 'chr', 'usdt', 6, 2, 'chrusdt');
INSERT INTO `symbol` VALUES (162, 'chz', 'btc', 8, 2, 'chzbtc');
INSERT INTO `symbol` VALUES (163, 'chz', 'eth', 8, 2, 'chzeth');
INSERT INTO `symbol` VALUES (164, 'chz', 'usdt', 6, 4, 'chzusdt');
INSERT INTO `symbol` VALUES (165, 'ckb', 'btc', 10, 2, 'ckbbtc');
INSERT INTO `symbol` VALUES (166, 'ckb', 'ht', 6, 2, 'ckbht');
INSERT INTO `symbol` VALUES (167, 'ckb', 'usdt', 6, 2, 'ckbusdt');
INSERT INTO `symbol` VALUES (168, 'cmt', 'btc', 10, 2, 'cmtbtc');
INSERT INTO `symbol` VALUES (169, 'cmt', 'eth', 8, 2, 'cmteth');
INSERT INTO `symbol` VALUES (170, 'cmt', 'usdt', 6, 4, 'cmtusdt');
INSERT INTO `symbol` VALUES (171, 'cnn', 'btc', 12, 2, 'cnnbtc');
INSERT INTO `symbol` VALUES (172, 'cnn', 'eth', 10, 2, 'cnneth');
INSERT INTO `symbol` VALUES (173, 'cnns', 'btc', 10, 2, 'cnnsbtc');
INSERT INTO `symbol` VALUES (174, 'cnns', 'ht', 6, 2, 'cnnsht');
INSERT INTO `symbol` VALUES (175, 'cnns', 'usdt', 6, 2, 'cnnsusdt');
INSERT INTO `symbol` VALUES (176, 'comp', 'btc', 6, 4, 'compbtc');
INSERT INTO `symbol` VALUES (177, 'comp', 'eth', 4, 2, 'competh');
INSERT INTO `symbol` VALUES (178, 'comp', 'usdt', 2, 6, 'compusdt');
INSERT INTO `symbol` VALUES (179, 'cova', 'btc', 10, 2, 'covabtc');
INSERT INTO `symbol` VALUES (180, 'cova', 'eth', 10, 4, 'covaeth');
INSERT INTO `symbol` VALUES (181, 'cre', 'btc', 10, 2, 'crebtc');
INSERT INTO `symbol` VALUES (182, 'cre', 'ht', 6, 2, 'creht');
INSERT INTO `symbol` VALUES (183, 'cre', 'usdt', 6, 2, 'creusdt');
INSERT INTO `symbol` VALUES (184, 'cro', 'btc', 8, 2, 'crobtc');
INSERT INTO `symbol` VALUES (185, 'cro', 'ht', 4, 2, 'croht');
INSERT INTO `symbol` VALUES (186, 'cro', 'usdt', 6, 2, 'crousdt');
INSERT INTO `symbol` VALUES (187, 'cru', 'btc', 8, 2, 'crubtc');
INSERT INTO `symbol` VALUES (188, 'cru', 'eth', 6, 4, 'crueth');
INSERT INTO `symbol` VALUES (189, 'cru', 'usdt', 4, 4, 'cruusdt');
INSERT INTO `symbol` VALUES (190, 'crv', 'btc', 7, 4, 'crvbtc');
INSERT INTO `symbol` VALUES (191, 'crv', 'eth', 6, 4, 'crveth');
INSERT INTO `symbol` VALUES (192, 'crv', 'husd', 4, 4, 'crvhusd');
INSERT INTO `symbol` VALUES (193, 'crv', 'usdt', 4, 4, 'crvusdt');
INSERT INTO `symbol` VALUES (194, 'ctxc', 'btc', 8, 2, 'ctxcbtc');
INSERT INTO `symbol` VALUES (195, 'ctxc', 'eth', 8, 2, 'ctxceth');
INSERT INTO `symbol` VALUES (196, 'ctxc', 'usdt', 4, 4, 'ctxcusdt');
INSERT INTO `symbol` VALUES (197, 'cvc', 'btc', 8, 0, 'cvcbtc');
INSERT INTO `symbol` VALUES (198, 'cvc', 'eth', 8, 0, 'cvceth');
INSERT INTO `symbol` VALUES (199, 'cvcoin', 'btc', 8, 2, 'cvcoinbtc');
INSERT INTO `symbol` VALUES (200, 'cvcoin', 'eth', 6, 4, 'cvcoineth');
INSERT INTO `symbol` VALUES (201, 'cvc', 'usdt', 4, 2, 'cvcusdt');
INSERT INTO `symbol` VALUES (202, 'cvnt', 'btc', 10, 2, 'cvntbtc');
INSERT INTO `symbol` VALUES (203, 'cvnt', 'eth', 8, 4, 'cvnteth');
INSERT INTO `symbol` VALUES (204, 'cvp', 'btc', 8, 2, 'cvpbtc');
INSERT INTO `symbol` VALUES (205, 'cvp', 'eth', 6, 4, 'cvpeth');
INSERT INTO `symbol` VALUES (206, 'cvp', 'usdt', 4, 4, 'cvpusdt');
INSERT INTO `symbol` VALUES (207, 'dac', 'btc', 10, 2, 'dacbtc');
INSERT INTO `symbol` VALUES (208, 'dac', 'eth', 8, 2, 'daceth');
INSERT INTO `symbol` VALUES (209, 'dac', 'usdt', 6, 2, 'dacusdt');
INSERT INTO `symbol` VALUES (210, 'dai', 'husd', 4, 4, 'daihusd');
INSERT INTO `symbol` VALUES (211, 'dai', 'usdt', 4, 2, 'daiusdt');
INSERT INTO `symbol` VALUES (212, 'dash', 'btc', 6, 4, 'dashbtc');
INSERT INTO `symbol` VALUES (213, 'dash', 'ht', 6, 4, 'dashht');
INSERT INTO `symbol` VALUES (214, 'dash', 'husd', 2, 4, 'dashhusd');
INSERT INTO `symbol` VALUES (215, 'dash', 'usdt', 2, 4, 'dashusdt');
INSERT INTO `symbol` VALUES (216, 'dat', 'btc', 10, 2, 'datbtc');
INSERT INTO `symbol` VALUES (217, 'dat', 'eth', 8, 2, 'dateth');
INSERT INTO `symbol` VALUES (218, 'datx', 'btc', 10, 2, 'datxbtc');
INSERT INTO `symbol` VALUES (219, 'datx', 'eth', 10, 2, 'datxeth');
INSERT INTO `symbol` VALUES (220, 'dbc', 'btc', 10, 2, 'dbcbtc');
INSERT INTO `symbol` VALUES (221, 'dbc', 'eth', 8, 2, 'dbceth');
INSERT INTO `symbol` VALUES (222, 'dcr', 'btc', 6, 4, 'dcrbtc');
INSERT INTO `symbol` VALUES (223, 'dcr', 'eth', 6, 4, 'dcreth');
INSERT INTO `symbol` VALUES (224, 'dcr', 'usdt', 4, 4, 'dcrusdt');
INSERT INTO `symbol` VALUES (225, 'df', 'btc', 8, 2, 'dfbtc');
INSERT INTO `symbol` VALUES (226, 'df', 'ht', 4, 2, 'dfht');
INSERT INTO `symbol` VALUES (227, 'df', 'usdt', 4, 2, 'dfusdt');
INSERT INTO `symbol` VALUES (228, 'dgb', 'btc', 10, 2, 'dgbbtc');
INSERT INTO `symbol` VALUES (229, 'dgb', 'eth', 8, 2, 'dgbeth');
INSERT INTO `symbol` VALUES (230, 'dgd', 'btc', 6, 4, 'dgdbtc');
INSERT INTO `symbol` VALUES (231, 'dgd', 'eth', 6, 4, 'dgdeth');
INSERT INTO `symbol` VALUES (232, 'dht', 'btc', 8, 2, 'dhtbtc');
INSERT INTO `symbol` VALUES (233, 'dht', 'eth', 8, 2, 'dhteth');
INSERT INTO `symbol` VALUES (234, 'dht', 'usdt', 4, 4, 'dhtusdt');
INSERT INTO `symbol` VALUES (235, 'dka', 'btc', 8, 2, 'dkabtc');
INSERT INTO `symbol` VALUES (236, 'dka', 'eth', 8, 2, 'dkaeth');
INSERT INTO `symbol` VALUES (237, 'dka', 'usdt', 6, 2, 'dkausdt');
INSERT INTO `symbol` VALUES (238, 'dock', 'btc', 8, 2, 'dockbtc');
INSERT INTO `symbol` VALUES (239, 'dock', 'eth', 8, 4, 'docketh');
INSERT INTO `symbol` VALUES (240, 'dock', 'usdt', 6, 2, 'dockusdt');
INSERT INTO `symbol` VALUES (241, 'doge', 'btc', 10, 2, 'dogebtc');
INSERT INTO `symbol` VALUES (242, 'doge', 'eth', 8, 2, 'dogeeth');
INSERT INTO `symbol` VALUES (243, 'doge', 'husd', 6, 4, 'dogehusd');
INSERT INTO `symbol` VALUES (244, 'doge', 'usdt', 6, 2, 'dogeusdt');
INSERT INTO `symbol` VALUES (245, 'dot2l', 'usdt', 4, 4, 'dot2lusdt');
INSERT INTO `symbol` VALUES (246, 'dot2s', 'usdt', 6, 4, 'dot2susdt');
INSERT INTO `symbol` VALUES (247, 'dot', 'btc', 8, 4, 'dotbtc');
INSERT INTO `symbol` VALUES (248, 'dot', 'husd', 4, 4, 'dothusd');
INSERT INTO `symbol` VALUES (249, 'dot', 'usdt', 4, 4, 'dotusdt');
INSERT INTO `symbol` VALUES (250, 'dta', 'btc', 10, 2, 'dtabtc');
INSERT INTO `symbol` VALUES (251, 'dta', 'eth', 8, 2, 'dtaeth');
INSERT INTO `symbol` VALUES (252, 'dta', 'usdt', 8, 4, 'dtausdt');
INSERT INTO `symbol` VALUES (253, 'edu', 'btc', 12, 2, 'edubtc');
INSERT INTO `symbol` VALUES (254, 'edu', 'eth', 10, 2, 'edueth');
INSERT INTO `symbol` VALUES (255, 'egcc', 'btc', 12, 2, 'egccbtc');
INSERT INTO `symbol` VALUES (256, 'egcc', 'eth', 10, 2, 'egcceth');
INSERT INTO `symbol` VALUES (257, 'egt', 'btc', 10, 2, 'egtbtc');
INSERT INTO `symbol` VALUES (258, 'egt', 'ht', 6, 2, 'egtht');
INSERT INTO `symbol` VALUES (259, 'egt', 'usdt', 6, 2, 'egtusdt');
INSERT INTO `symbol` VALUES (260, 'eko', 'btc', 10, 2, 'ekobtc');
INSERT INTO `symbol` VALUES (261, 'eko', 'eth', 8, 2, 'ekoeth');
INSERT INTO `symbol` VALUES (262, 'ekt', 'btc', 10, 2, 'ektbtc');
INSERT INTO `symbol` VALUES (263, 'ekt', 'eth', 8, 4, 'ekteth');
INSERT INTO `symbol` VALUES (264, 'ekt', 'usdt', 6, 2, 'ektusdt');
INSERT INTO `symbol` VALUES (265, 'ela', 'btc', 8, 2, 'elabtc');
INSERT INTO `symbol` VALUES (266, 'ela', 'eth', 8, 2, 'elaeth');
INSERT INTO `symbol` VALUES (267, 'ela', 'usdt', 4, 2, 'elausdt');
INSERT INTO `symbol` VALUES (268, 'elf', 'btc', 8, 0, 'elfbtc');
INSERT INTO `symbol` VALUES (269, 'elf', 'eth', 8, 0, 'elfeth');
INSERT INTO `symbol` VALUES (270, 'elf', 'usdt', 4, 4, 'elfusdt');
INSERT INTO `symbol` VALUES (271, 'em', 'btc', 10, 2, 'embtc');
INSERT INTO `symbol` VALUES (272, 'em', 'ht', 8, 2, 'emht');
INSERT INTO `symbol` VALUES (273, 'em', 'usdt', 6, 2, 'emusdt');
INSERT INTO `symbol` VALUES (274, 'eng', 'btc', 8, 2, 'engbtc');
INSERT INTO `symbol` VALUES (275, 'eng', 'eth', 6, 4, 'engeth');
INSERT INTO `symbol` VALUES (276, 'eos3l', 'usdt', 4, 4, 'eos3lusdt');
INSERT INTO `symbol` VALUES (277, 'eos3s', 'usdt', 6, 4, 'eos3susdt');
INSERT INTO `symbol` VALUES (278, 'eos', 'btc', 8, 2, 'eosbtc');
INSERT INTO `symbol` VALUES (279, 'eos', 'eth', 8, 2, 'eoseth');
INSERT INTO `symbol` VALUES (280, 'eos', 'ht', 6, 4, 'eosht');
INSERT INTO `symbol` VALUES (281, 'eos', 'husd', 4, 4, 'eoshusd');
INSERT INTO `symbol` VALUES (282, 'eos', 'usdt', 4, 4, 'eosusdt');
INSERT INTO `symbol` VALUES (283, 'etc', 'btc', 6, 4, 'etcbtc');
INSERT INTO `symbol` VALUES (284, 'etc', 'ht', 6, 4, 'etcht');
INSERT INTO `symbol` VALUES (285, 'etc', 'husd', 4, 4, 'etchusd');
INSERT INTO `symbol` VALUES (286, 'etc', 'usdt', 4, 4, 'etcusdt');
INSERT INTO `symbol` VALUES (287, 'eth1s', 'usdt', 4, 4, 'eth1susdt');
INSERT INTO `symbol` VALUES (288, 'eth3l', 'usdt', 4, 4, 'eth3lusdt');
INSERT INTO `symbol` VALUES (289, 'eth3s', 'usdt', 6, 4, 'eth3susdt');
INSERT INTO `symbol` VALUES (290, 'eth', 'btc', 6, 4, 'ethbtc');
INSERT INTO `symbol` VALUES (291, 'eth', 'husd', 2, 4, 'ethhusd');
INSERT INTO `symbol` VALUES (292, 'eth', 'usdt', 2, 4, 'ethusdt');
INSERT INTO `symbol` VALUES (293, 'etn', 'btc', 10, 2, 'etnbtc');
INSERT INTO `symbol` VALUES (294, 'etn', 'eth', 8, 4, 'etneth');
INSERT INTO `symbol` VALUES (295, 'evx', 'btc', 8, 2, 'evxbtc');
INSERT INTO `symbol` VALUES (296, 'evx', 'eth', 8, 2, 'evxeth');
INSERT INTO `symbol` VALUES (297, 'fair', 'btc', 10, 2, 'fairbtc');
INSERT INTO `symbol` VALUES (298, 'fair', 'eth', 8, 2, 'faireth');
INSERT INTO `symbol` VALUES (299, 'fil3l', 'usdt', 4, 4, 'fil3lusdt');
INSERT INTO `symbol` VALUES (300, 'fil3s', 'usdt', 4, 4, 'fil3susdt');
INSERT INTO `symbol` VALUES (301, 'fil', 'btc', 6, 4, 'filbtc');
INSERT INTO `symbol` VALUES (302, 'fil', 'eth', 6, 4, 'fileth');
INSERT INTO `symbol` VALUES (303, 'fil', 'husd', 4, 4, 'filhusd');
INSERT INTO `symbol` VALUES (304, 'fil', 'usdt', 4, 4, 'filusdt');
INSERT INTO `symbol` VALUES (305, 'firo', 'btc', 6, 4, 'firobtc');
INSERT INTO `symbol` VALUES (306, 'firo', 'eth', 6, 4, 'firoeth');
INSERT INTO `symbol` VALUES (307, 'firo', 'usdt', 4, 4, 'firousdt');
INSERT INTO `symbol` VALUES (308, 'fis', 'btc', 8, 2, 'fisbtc');
INSERT INTO `symbol` VALUES (309, 'fis', 'eth', 6, 2, 'fiseth');
INSERT INTO `symbol` VALUES (310, 'fis', 'usdt', 4, 2, 'fisusdt');
INSERT INTO `symbol` VALUES (311, 'flow', 'btc', 8, 4, 'flowbtc');
INSERT INTO `symbol` VALUES (312, 'flow', 'eth', 6, 4, 'floweth');
INSERT INTO `symbol` VALUES (313, 'flow', 'usdt', 4, 4, 'flowusdt');
INSERT INTO `symbol` VALUES (314, 'for', 'btc', 8, 2, 'forbtc');
INSERT INTO `symbol` VALUES (315, 'for', 'ht', 6, 2, 'forht');
INSERT INTO `symbol` VALUES (316, 'for', 'usdt', 6, 2, 'forusdt');
INSERT INTO `symbol` VALUES (317, 'front', 'btc', 8, 2, 'frontbtc');
INSERT INTO `symbol` VALUES (318, 'front', 'eth', 8, 2, 'fronteth');
INSERT INTO `symbol` VALUES (319, 'front', 'usdt', 6, 4, 'frontusdt');
INSERT INTO `symbol` VALUES (320, 'fsn', 'btc', 8, 2, 'fsnbtc');
INSERT INTO `symbol` VALUES (321, 'fsn', 'ht', 6, 4, 'fsnht');
INSERT INTO `symbol` VALUES (322, 'fsn', 'usdt', 4, 4, 'fsnusdt');
INSERT INTO `symbol` VALUES (323, 'fti', 'btc', 10, 2, 'ftibtc');
INSERT INTO `symbol` VALUES (324, 'fti', 'eth', 10, 2, 'ftieth');
INSERT INTO `symbol` VALUES (325, 'fti', 'usdt', 6, 2, 'ftiusdt');
INSERT INTO `symbol` VALUES (326, 'ftt', 'btc', 8, 2, 'fttbtc');
INSERT INTO `symbol` VALUES (327, 'ftt', 'ht', 6, 4, 'fttht');
INSERT INTO `symbol` VALUES (328, 'ftt', 'usdt', 4, 4, 'fttusdt');
INSERT INTO `symbol` VALUES (329, 'gas', 'btc', 6, 4, 'gasbtc');
INSERT INTO `symbol` VALUES (330, 'gas', 'eth', 6, 4, 'gaseth');
INSERT INTO `symbol` VALUES (331, 'get', 'btc', 10, 2, 'getbtc');
INSERT INTO `symbol` VALUES (332, 'get', 'eth', 8, 2, 'geteth');
INSERT INTO `symbol` VALUES (333, 'glm', 'btc', 8, 2, 'glmbtc');
INSERT INTO `symbol` VALUES (334, 'glm', 'eth', 8, 2, 'glmeth');
INSERT INTO `symbol` VALUES (335, 'glm', 'usdt', 4, 4, 'glmusdt');
INSERT INTO `symbol` VALUES (336, 'gnx', 'btc', 10, 0, 'gnxbtc');
INSERT INTO `symbol` VALUES (337, 'gnx', 'eth', 8, 0, 'gnxeth');
INSERT INTO `symbol` VALUES (338, 'gnx', 'usdt', 6, 2, 'gnxusdt');
INSERT INTO `symbol` VALUES (339, 'gof', 'btc', 8, 2, 'gofbtc');
INSERT INTO `symbol` VALUES (340, 'gof', 'eth', 6, 2, 'gofeth');
INSERT INTO `symbol` VALUES (341, 'gof', 'usdt', 4, 2, 'gofusdt');
INSERT INTO `symbol` VALUES (342, 'grs', 'btc', 8, 2, 'grsbtc');
INSERT INTO `symbol` VALUES (343, 'grs', 'eth', 6, 4, 'grseth');
INSERT INTO `symbol` VALUES (344, 'grt', 'btc', 8, 2, 'grtbtc');
INSERT INTO `symbol` VALUES (345, 'grt', 'eth', 8, 2, 'grteth');
INSERT INTO `symbol` VALUES (346, 'grt', 'usdt', 6, 4, 'grtusdt');
INSERT INTO `symbol` VALUES (347, 'gsc', 'btc', 10, 2, 'gscbtc');
INSERT INTO `symbol` VALUES (348, 'gsc', 'eth', 8, 2, 'gsceth');
INSERT INTO `symbol` VALUES (349, 'gt', 'btc', 8, 2, 'gtbtc');
INSERT INTO `symbol` VALUES (350, 'gtc', 'btc', 10, 2, 'gtcbtc');
INSERT INTO `symbol` VALUES (351, 'gtc', 'eth', 8, 2, 'gtceth');
INSERT INTO `symbol` VALUES (352, 'gt', 'ht', 6, 2, 'gtht');
INSERT INTO `symbol` VALUES (353, 'gt', 'usdt', 4, 2, 'gtusdt');
INSERT INTO `symbol` VALUES (354, 'gve', 'btc', 12, 2, 'gvebtc');
INSERT INTO `symbol` VALUES (355, 'gve', 'eth', 8, 2, 'gveeth');
INSERT INTO `symbol` VALUES (356, 'gxc', 'btc', 8, 2, 'gxcbtc');
INSERT INTO `symbol` VALUES (357, 'gxc', 'eth', 6, 4, 'gxceth');
INSERT INTO `symbol` VALUES (358, 'gxc', 'usdt', 4, 4, 'gxcusdt');
INSERT INTO `symbol` VALUES (359, 'hb10', 'usdt', 4, 4, 'hb10usdt');
INSERT INTO `symbol` VALUES (360, 'hbar', 'btc', 8, 2, 'hbarbtc');
INSERT INTO `symbol` VALUES (361, 'hbar', 'eth', 8, 2, 'hbareth');
INSERT INTO `symbol` VALUES (362, 'hbar', 'usdt', 6, 2, 'hbarusdt');
INSERT INTO `symbol` VALUES (363, 'hbc', 'btc', 8, 2, 'hbcbtc');
INSERT INTO `symbol` VALUES (364, 'hbc', 'ht', 6, 2, 'hbcht');
INSERT INTO `symbol` VALUES (365, 'hbc', 'usdt', 4, 2, 'hbcusdt');
INSERT INTO `symbol` VALUES (366, 'hc', 'btc', 8, 4, 'hcbtc');
INSERT INTO `symbol` VALUES (367, 'hc', 'eth', 6, 4, 'hceth');
INSERT INTO `symbol` VALUES (368, 'hc', 'usdt', 4, 4, 'hcusdt');
INSERT INTO `symbol` VALUES (369, 'hit', 'btc', 12, 2, 'hitbtc');
INSERT INTO `symbol` VALUES (370, 'hit', 'eth', 10, 2, 'hiteth');
INSERT INTO `symbol` VALUES (371, 'hit', 'usdt', 8, 4, 'hitusdt');
INSERT INTO `symbol` VALUES (372, 'hive', 'btc', 8, 2, 'hivebtc');
INSERT INTO `symbol` VALUES (373, 'hive', 'ht', 6, 2, 'hiveht');
INSERT INTO `symbol` VALUES (374, 'hive', 'usdt', 4, 2, 'hiveusdt');
INSERT INTO `symbol` VALUES (375, 'hot', 'btc', 10, 2, 'hotbtc');
INSERT INTO `symbol` VALUES (376, 'hot', 'eth', 8, 2, 'hoteth');
INSERT INTO `symbol` VALUES (377, 'hot', 'usdt', 6, 2, 'hotusdt');
INSERT INTO `symbol` VALUES (378, 'hpt', 'btc', 10, 2, 'hptbtc');
INSERT INTO `symbol` VALUES (379, 'hpt', 'ht', 6, 4, 'hptht');
INSERT INTO `symbol` VALUES (380, 'hpt', 'usdt', 6, 4, 'hptusdt');
INSERT INTO `symbol` VALUES (381, 'ht', 'btc', 8, 2, 'htbtc');
INSERT INTO `symbol` VALUES (382, 'ht', 'eth', 8, 2, 'hteth');
INSERT INTO `symbol` VALUES (383, 'ht', 'husd', 4, 2, 'hthusd');
INSERT INTO `symbol` VALUES (384, 'ht', 'usdt', 4, 2, 'htusdt');
INSERT INTO `symbol` VALUES (385, 'icx', 'btc', 8, 4, 'icxbtc');
INSERT INTO `symbol` VALUES (386, 'icx', 'eth', 6, 4, 'icxeth');
INSERT INTO `symbol` VALUES (387, 'icx', 'usdt', 4, 4, 'icxusdt');
INSERT INTO `symbol` VALUES (388, 'idt', 'btc', 10, 2, 'idtbtc');
INSERT INTO `symbol` VALUES (389, 'idt', 'eth', 8, 2, 'idteth');
INSERT INTO `symbol` VALUES (390, 'iic', 'btc', 12, 2, 'iicbtc');
INSERT INTO `symbol` VALUES (391, 'iic', 'eth', 10, 2, 'iiceth');
INSERT INTO `symbol` VALUES (392, 'inj', 'btc', 8, 2, 'injbtc');
INSERT INTO `symbol` VALUES (393, 'inj', 'eth', 8, 2, 'injeth');
INSERT INTO `symbol` VALUES (394, 'inj', 'usdt', 4, 4, 'injusdt');
INSERT INTO `symbol` VALUES (395, 'iost', 'btc', 10, 2, 'iostbtc');
INSERT INTO `symbol` VALUES (396, 'iost', 'eth', 8, 2, 'iosteth');
INSERT INTO `symbol` VALUES (397, 'iost', 'ht', 8, 4, 'iostht');
INSERT INTO `symbol` VALUES (398, 'iost', 'husd', 6, 4, 'iosthusd');
INSERT INTO `symbol` VALUES (399, 'iost', 'usdt', 6, 4, 'iostusdt');
INSERT INTO `symbol` VALUES (400, 'iota', 'btc', 8, 2, 'iotabtc');
INSERT INTO `symbol` VALUES (401, 'iota', 'eth', 6, 4, 'iotaeth');
INSERT INTO `symbol` VALUES (402, 'iota', 'usdt', 4, 4, 'iotausdt');
INSERT INTO `symbol` VALUES (403, 'iotx', 'btc', 10, 2, 'iotxbtc');
INSERT INTO `symbol` VALUES (404, 'iotx', 'eth', 8, 2, 'iotxeth');
INSERT INTO `symbol` VALUES (405, 'iotx', 'usdt', 6, 2, 'iotxusdt');
INSERT INTO `symbol` VALUES (406, 'iris', 'btc', 10, 2, 'irisbtc');
INSERT INTO `symbol` VALUES (407, 'iris', 'eth', 6, 4, 'iriseth');
INSERT INTO `symbol` VALUES (408, 'iris', 'husd', 6, 2, 'irishusd');
INSERT INTO `symbol` VALUES (409, 'iris', 'usdt', 6, 2, 'irisusdt');
INSERT INTO `symbol` VALUES (410, 'itc', 'btc', 8, 0, 'itcbtc');
INSERT INTO `symbol` VALUES (411, 'itc', 'eth', 8, 0, 'itceth');
INSERT INTO `symbol` VALUES (412, 'itc', 'usdt', 4, 4, 'itcusdt');
INSERT INTO `symbol` VALUES (413, 'jst', 'btc', 10, 2, 'jstbtc');
INSERT INTO `symbol` VALUES (414, 'jst', 'eth', 8, 2, 'jsteth');
INSERT INTO `symbol` VALUES (415, 'jst', 'usdt', 6, 2, 'jstusdt');
INSERT INTO `symbol` VALUES (416, 'kan', 'btc', 10, 2, 'kanbtc');
INSERT INTO `symbol` VALUES (417, 'kan', 'eth', 8, 2, 'kaneth');
INSERT INTO `symbol` VALUES (418, 'kan', 'usdt', 6, 4, 'kanusdt');
INSERT INTO `symbol` VALUES (419, 'kava', 'btc', 8, 2, 'kavabtc');
INSERT INTO `symbol` VALUES (420, 'kava', 'eth', 6, 2, 'kavaeth');
INSERT INTO `symbol` VALUES (421, 'kava', 'husd', 4, 4, 'kavahusd');
INSERT INTO `symbol` VALUES (422, 'kava', 'usdt', 4, 2, 'kavausdt');
INSERT INTO `symbol` VALUES (423, 'kcash', 'btc', 10, 2, 'kcashbtc');
INSERT INTO `symbol` VALUES (424, 'kcash', 'eth', 8, 2, 'kcasheth');
INSERT INTO `symbol` VALUES (425, 'kcash', 'ht', 6, 4, 'kcashht');
INSERT INTO `symbol` VALUES (426, 'kcash', 'usdt', 6, 2, 'kcashusdt');
INSERT INTO `symbol` VALUES (427, 'kmd', 'btc', 8, 2, 'kmdbtc');
INSERT INTO `symbol` VALUES (428, 'kmd', 'eth', 6, 4, 'kmdeth');
INSERT INTO `symbol` VALUES (429, 'knc', 'btc', 8, 0, 'kncbtc');
INSERT INTO `symbol` VALUES (430, 'knc', 'eth', 8, 2, 'knceth');
INSERT INTO `symbol` VALUES (431, 'knc', 'husd', 4, 4, 'knchusd');
INSERT INTO `symbol` VALUES (432, 'knc', 'usdt', 4, 2, 'kncusdt');
INSERT INTO `symbol` VALUES (433, 'ksm', 'btc', 8, 2, 'ksmbtc');
INSERT INTO `symbol` VALUES (434, 'ksm', 'ht', 6, 2, 'ksmht');
INSERT INTO `symbol` VALUES (435, 'ksm', 'husd', 4, 4, 'ksmhusd');
INSERT INTO `symbol` VALUES (436, 'ksm', 'usdt', 4, 2, 'ksmusdt');
INSERT INTO `symbol` VALUES (437, 'lamb', 'btc', 8, 2, 'lambbtc');
INSERT INTO `symbol` VALUES (438, 'lamb', 'eth', 8, 2, 'lambeth');
INSERT INTO `symbol` VALUES (439, 'lamb', 'ht', 6, 4, 'lambht');
INSERT INTO `symbol` VALUES (440, 'lamb', 'usdt', 6, 4, 'lambusdt');
INSERT INTO `symbol` VALUES (441, 'lba', 'btc', 9, 2, 'lbabtc');
INSERT INTO `symbol` VALUES (442, 'lba', 'eth', 8, 4, 'lbaeth');
INSERT INTO `symbol` VALUES (443, 'lba', 'usdt', 6, 4, 'lbausdt');
INSERT INTO `symbol` VALUES (444, 'lend', 'btc', 8, 2, 'lendbtc');
INSERT INTO `symbol` VALUES (445, 'lend', 'eth', 6, 2, 'lendeth');
INSERT INTO `symbol` VALUES (446, 'lend', 'usdt', 4, 2, 'lendusdt');
INSERT INTO `symbol` VALUES (447, 'let', 'btc', 10, 2, 'letbtc');
INSERT INTO `symbol` VALUES (448, 'let', 'eth', 8, 2, 'leteth');
INSERT INTO `symbol` VALUES (449, 'let', 'usdt', 6, 4, 'letusdt');
INSERT INTO `symbol` VALUES (450, 'lina', 'btc', 10, 2, 'linabtc');
INSERT INTO `symbol` VALUES (451, 'lina', 'eth', 8, 2, 'linaeth');
INSERT INTO `symbol` VALUES (452, 'lina', 'usdt', 6, 4, 'linausdt');
INSERT INTO `symbol` VALUES (453, 'link3l', 'usdt', 4, 4, 'link3lusdt');
INSERT INTO `symbol` VALUES (454, 'link3s', 'usdt', 6, 4, 'link3susdt');
INSERT INTO `symbol` VALUES (455, 'link', 'btc', 8, 2, 'linkbtc');
INSERT INTO `symbol` VALUES (456, 'link', 'eth', 8, 2, 'linketh');
INSERT INTO `symbol` VALUES (457, 'link', 'husd', 4, 4, 'linkhusd');
INSERT INTO `symbol` VALUES (458, 'link', 'usdt', 4, 2, 'linkusdt');
INSERT INTO `symbol` VALUES (459, 'lol', 'btc', 10, 2, 'lolbtc');
INSERT INTO `symbol` VALUES (460, 'lol', 'ht', 8, 4, 'lolht');
INSERT INTO `symbol` VALUES (461, 'lol', 'usdt', 6, 4, 'lolusdt');
INSERT INTO `symbol` VALUES (462, 'loom', 'btc', 8, 2, 'loombtc');
INSERT INTO `symbol` VALUES (463, 'loom', 'eth', 8, 4, 'loometh');
INSERT INTO `symbol` VALUES (464, 'loom', 'usdt', 6, 2, 'loomusdt');
INSERT INTO `symbol` VALUES (465, 'lrc', 'btc', 8, 2, 'lrcbtc');
INSERT INTO `symbol` VALUES (466, 'lrc', 'eth', 8, 2, 'lrceth');
INSERT INTO `symbol` VALUES (467, 'lrc', 'usdt', 4, 4, 'lrcusdt');
INSERT INTO `symbol` VALUES (468, 'lsk', 'btc', 8, 4, 'lskbtc');
INSERT INTO `symbol` VALUES (469, 'lsk', 'eth', 6, 4, 'lsketh');
INSERT INTO `symbol` VALUES (470, 'ltc3l', 'usdt', 4, 4, 'ltc3lusdt');
INSERT INTO `symbol` VALUES (471, 'ltc3s', 'usdt', 6, 4, 'ltc3susdt');
INSERT INTO `symbol` VALUES (472, 'ltc', 'btc', 6, 4, 'ltcbtc');
INSERT INTO `symbol` VALUES (473, 'ltc', 'ht', 6, 4, 'ltcht');
INSERT INTO `symbol` VALUES (474, 'ltc', 'husd', 2, 4, 'ltchusd');
INSERT INTO `symbol` VALUES (475, 'ltc', 'usdt', 2, 4, 'ltcusdt');
INSERT INTO `symbol` VALUES (476, 'luna', 'btc', 8, 2, 'lunabtc');
INSERT INTO `symbol` VALUES (477, 'luna', 'ht', 6, 2, 'lunaht');
INSERT INTO `symbol` VALUES (478, 'luna', 'usdt', 4, 2, 'lunausdt');
INSERT INTO `symbol` VALUES (479, 'lun', 'btc', 8, 4, 'lunbtc');
INSERT INTO `symbol` VALUES (480, 'lun', 'eth', 6, 4, 'luneth');
INSERT INTO `symbol` VALUES (481, 'lxt', 'btc', 10, 2, 'lxtbtc');
INSERT INTO `symbol` VALUES (482, 'lxt', 'eth', 8, 2, 'lxteth');
INSERT INTO `symbol` VALUES (483, 'lxt', 'usdt', 6, 2, 'lxtusdt');
INSERT INTO `symbol` VALUES (484, 'lym', 'btc', 10, 2, 'lymbtc');
INSERT INTO `symbol` VALUES (485, 'lym', 'eth', 8, 2, 'lymeth');
INSERT INTO `symbol` VALUES (486, 'mana', 'btc', 8, 0, 'manabtc');
INSERT INTO `symbol` VALUES (487, 'mana', 'eth', 8, 0, 'manaeth');
INSERT INTO `symbol` VALUES (488, 'mana', 'usdt', 4, 2, 'manausdt');
INSERT INTO `symbol` VALUES (489, 'man', 'btc', 10, 2, 'manbtc');
INSERT INTO `symbol` VALUES (490, 'man', 'eth', 8, 4, 'maneth');
INSERT INTO `symbol` VALUES (491, 'mask', 'usdt', 4, 4, 'maskusdt');
INSERT INTO `symbol` VALUES (492, 'mass', 'btc', 8, 2, 'massbtc');
INSERT INTO `symbol` VALUES (493, 'mass', 'eth', 6, 2, 'masseth');
INSERT INTO `symbol` VALUES (494, 'mass', 'usdt', 4, 2, 'massusdt');
INSERT INTO `symbol` VALUES (495, 'matic', 'btc', 10, 2, 'maticbtc');
INSERT INTO `symbol` VALUES (496, 'matic', 'eth', 8, 2, 'maticeth');
INSERT INTO `symbol` VALUES (497, 'matic', 'usdt', 6, 4, 'maticusdt');
INSERT INTO `symbol` VALUES (498, 'mco', 'btc', 6, 4, 'mcobtc');
INSERT INTO `symbol` VALUES (499, 'mco', 'eth', 6, 4, 'mcoeth');
INSERT INTO `symbol` VALUES (500, 'mco', 'usdt', 4, 2, 'mcousdt');
INSERT INTO `symbol` VALUES (501, 'mds', 'btc', 10, 0, 'mdsbtc');
INSERT INTO `symbol` VALUES (502, 'mds', 'eth', 8, 0, 'mdseth');
INSERT INTO `symbol` VALUES (503, 'mds', 'usdt', 6, 2, 'mdsusdt');
INSERT INTO `symbol` VALUES (504, 'mdx', 'btc', 8, 2, 'mdxbtc');
INSERT INTO `symbol` VALUES (505, 'mdx', 'eth', 6, 2, 'mdxeth');
INSERT INTO `symbol` VALUES (506, 'mdx', 'ht', 4, 2, 'mdxht');
INSERT INTO `symbol` VALUES (507, 'mdx', 'usdt', 4, 2, 'mdxusdt');
INSERT INTO `symbol` VALUES (508, 'meet', 'btc', 10, 2, 'meetbtc');
INSERT INTO `symbol` VALUES (509, 'meet', 'eth', 8, 2, 'meeteth');
INSERT INTO `symbol` VALUES (510, 'mex', 'btc', 10, 2, 'mexbtc');
INSERT INTO `symbol` VALUES (511, 'mex', 'eth', 10, 2, 'mexeth');
INSERT INTO `symbol` VALUES (512, 'mkr', 'btc', 6, 4, 'mkrbtc');
INSERT INTO `symbol` VALUES (513, 'mkr', 'eth', 4, 6, 'mkreth');
INSERT INTO `symbol` VALUES (514, 'mkr', 'husd', 2, 6, 'mkrhusd');
INSERT INTO `symbol` VALUES (515, 'mkr', 'usdt', 2, 6, 'mkrusdt');
INSERT INTO `symbol` VALUES (516, 'mln', 'btc', 6, 4, 'mlnbtc');
INSERT INTO `symbol` VALUES (517, 'mln', 'eth', 6, 4, 'mlneth');
INSERT INTO `symbol` VALUES (518, 'mln', 'usdt', 4, 4, 'mlnusdt');
INSERT INTO `symbol` VALUES (519, 'mta', 'btc', 8, 4, 'mtabtc');
INSERT INTO `symbol` VALUES (520, 'mta', 'eth', 6, 4, 'mtaeth');
INSERT INTO `symbol` VALUES (521, 'mta', 'usdt', 4, 4, 'mtausdt');
INSERT INTO `symbol` VALUES (522, 'mt', 'btc', 10, 2, 'mtbtc');
INSERT INTO `symbol` VALUES (523, 'mt', 'eth', 8, 2, 'mteth');
INSERT INTO `symbol` VALUES (524, 'mt', 'ht', 6, 4, 'mtht');
INSERT INTO `symbol` VALUES (525, 'mtl', 'btc', 8, 4, 'mtlbtc');
INSERT INTO `symbol` VALUES (526, 'mtn', 'btc', 10, 2, 'mtnbtc');
INSERT INTO `symbol` VALUES (527, 'mtn', 'eth', 8, 2, 'mtneth');
INSERT INTO `symbol` VALUES (528, 'mtx', 'btc', 8, 2, 'mtxbtc');
INSERT INTO `symbol` VALUES (529, 'mtx', 'eth', 8, 2, 'mtxeth');
INSERT INTO `symbol` VALUES (530, 'musk', 'btc', 10, 2, 'muskbtc');
INSERT INTO `symbol` VALUES (531, 'musk', 'eth', 8, 2, 'musketh');
INSERT INTO `symbol` VALUES (532, 'mx', 'btc', 8, 2, 'mxbtc');
INSERT INTO `symbol` VALUES (533, 'mxc', 'btc', 10, 2, 'mxcbtc');
INSERT INTO `symbol` VALUES (534, 'mxc', 'usdt', 6, 2, 'mxcusdt');
INSERT INTO `symbol` VALUES (535, 'mx', 'ht', 6, 2, 'mxht');
INSERT INTO `symbol` VALUES (536, 'mx', 'usdt', 4, 2, 'mxusdt');
INSERT INTO `symbol` VALUES (537, 'nano', 'btc', 7, 2, 'nanobtc');
INSERT INTO `symbol` VALUES (538, 'nano', 'eth', 6, 4, 'nanoeth');
INSERT INTO `symbol` VALUES (539, 'nano', 'usdt', 4, 4, 'nanousdt');
INSERT INTO `symbol` VALUES (540, 'nas', 'btc', 8, 4, 'nasbtc');
INSERT INTO `symbol` VALUES (541, 'nas', 'eth', 6, 4, 'naseth');
INSERT INTO `symbol` VALUES (542, 'nas', 'usdt', 4, 4, 'nasusdt');
INSERT INTO `symbol` VALUES (543, 'nbs', 'btc', 10, 2, 'nbsbtc');
INSERT INTO `symbol` VALUES (544, 'nbs', 'usdt', 6, 2, 'nbsusdt');
INSERT INTO `symbol` VALUES (545, 'ncash', 'btc', 10, 2, 'ncashbtc');
INSERT INTO `symbol` VALUES (546, 'ncash', 'eth', 10, 2, 'ncasheth');
INSERT INTO `symbol` VALUES (547, 'ncc', 'btc', 10, 2, 'nccbtc');
INSERT INTO `symbol` VALUES (548, 'ncc', 'eth', 10, 2, 'ncceth');
INSERT INTO `symbol` VALUES (549, 'near', 'btc', 8, 2, 'nearbtc');
INSERT INTO `symbol` VALUES (550, 'near', 'eth', 6, 2, 'neareth');
INSERT INTO `symbol` VALUES (551, 'near', 'usdt', 4, 2, 'nearusdt');
INSERT INTO `symbol` VALUES (552, 'neo', 'btc', 6, 4, 'neobtc');
INSERT INTO `symbol` VALUES (553, 'neo', 'husd', 4, 4, 'neohusd');
INSERT INTO `symbol` VALUES (554, 'neo', 'usdt', 2, 4, 'neousdt');
INSERT INTO `symbol` VALUES (555, 'nest', 'btc', 8, 2, 'nestbtc');
INSERT INTO `symbol` VALUES (556, 'nest', 'eth', 8, 2, 'nesteth');
INSERT INTO `symbol` VALUES (557, 'nest', 'ht', 6, 2, 'nestht');
INSERT INTO `symbol` VALUES (558, 'nest', 'husd', 4, 2, 'nesthusd');
INSERT INTO `symbol` VALUES (559, 'nest', 'usdt', 4, 2, 'nestusdt');
INSERT INTO `symbol` VALUES (560, 'new', 'btc', 10, 2, 'newbtc');
INSERT INTO `symbol` VALUES (561, 'new', 'ht', 6, 4, 'newht');
INSERT INTO `symbol` VALUES (562, 'new', 'usdt', 6, 4, 'newusdt');
INSERT INTO `symbol` VALUES (563, 'nexo', 'btc', 8, 2, 'nexobtc');
INSERT INTO `symbol` VALUES (564, 'nexo', 'eth', 6, 4, 'nexoeth');
INSERT INTO `symbol` VALUES (565, 'nexo', 'usdt', 4, 2, 'nexousdt');
INSERT INTO `symbol` VALUES (566, 'nhbtc', 'eth', 6, 4, 'nhbtceth');
INSERT INTO `symbol` VALUES (567, 'nhbtc', 'usdt', 4, 4, 'nhbtcusdt');
INSERT INTO `symbol` VALUES (568, 'nkn', 'btc', 8, 2, 'nknbtc');
INSERT INTO `symbol` VALUES (569, 'nkn', 'ht', 6, 2, 'nknht');
INSERT INTO `symbol` VALUES (570, 'nkn', 'usdt', 6, 2, 'nknusdt');
INSERT INTO `symbol` VALUES (571, 'node', 'btc', 10, 2, 'nodebtc');
INSERT INTO `symbol` VALUES (572, 'node', 'ht', 6, 2, 'nodeht');
INSERT INTO `symbol` VALUES (573, 'node', 'usdt', 6, 2, 'nodeusdt');
INSERT INTO `symbol` VALUES (574, 'npxs', 'btc', 10, 2, 'npxsbtc');
INSERT INTO `symbol` VALUES (575, 'npxs', 'eth', 10, 2, 'npxseth');
INSERT INTO `symbol` VALUES (576, 'nsure', 'btc', 8, 2, 'nsurebtc');
INSERT INTO `symbol` VALUES (577, 'nsure', 'eth', 6, 4, 'nsureeth');
INSERT INTO `symbol` VALUES (578, 'nsure', 'usdt', 4, 4, 'nsureusdt');
INSERT INTO `symbol` VALUES (579, 'nuls', 'btc', 8, 2, 'nulsbtc');
INSERT INTO `symbol` VALUES (580, 'nuls', 'eth', 6, 4, 'nulseth');
INSERT INTO `symbol` VALUES (581, 'nuls', 'usdt', 4, 2, 'nulsusdt');
INSERT INTO `symbol` VALUES (582, 'ocn', 'btc', 10, 2, 'ocnbtc');
INSERT INTO `symbol` VALUES (583, 'ocn', 'eth', 10, 2, 'ocneth');
INSERT INTO `symbol` VALUES (584, 'ocn', 'usdt', 8, 4, 'ocnusdt');
INSERT INTO `symbol` VALUES (585, 'ogn', 'btc', 8, 2, 'ognbtc');
INSERT INTO `symbol` VALUES (586, 'ogn', 'ht', 6, 2, 'ognht');
INSERT INTO `symbol` VALUES (587, 'ogn', 'usdt', 4, 2, 'ognusdt');
INSERT INTO `symbol` VALUES (588, 'ogo', 'btc', 10, 2, 'ogobtc');
INSERT INTO `symbol` VALUES (589, 'ogo', 'ht', 6, 2, 'ogoht');
INSERT INTO `symbol` VALUES (590, 'ogo', 'usdt', 6, 2, 'ogousdt');
INSERT INTO `symbol` VALUES (591, 'omg', 'btc', 6, 4, 'omgbtc');
INSERT INTO `symbol` VALUES (592, 'omg', 'eth', 6, 4, 'omgeth');
INSERT INTO `symbol` VALUES (593, 'omg', 'husd', 4, 4, 'omghusd');
INSERT INTO `symbol` VALUES (594, 'omg', 'usdt', 4, 4, 'omgusdt');
INSERT INTO `symbol` VALUES (595, 'one', 'btc', 10, 2, 'onebtc');
INSERT INTO `symbol` VALUES (596, 'one', 'ht', 6, 2, 'oneht');
INSERT INTO `symbol` VALUES (597, 'one', 'usdt', 6, 2, 'oneusdt');
INSERT INTO `symbol` VALUES (598, 'ont', 'btc', 8, 4, 'ontbtc');
INSERT INTO `symbol` VALUES (599, 'ont', 'eth', 8, 4, 'onteth');
INSERT INTO `symbol` VALUES (600, 'ont', 'husd', 4, 4, 'onthusd');
INSERT INTO `symbol` VALUES (601, 'ont', 'usdt', 4, 4, 'ontusdt');
INSERT INTO `symbol` VALUES (602, 'ost', 'btc', 8, 2, 'ostbtc');
INSERT INTO `symbol` VALUES (603, 'ost', 'eth', 8, 2, 'osteth');
INSERT INTO `symbol` VALUES (604, 'oxt', 'btc', 8, 2, 'oxtbtc');
INSERT INTO `symbol` VALUES (605, 'oxt', 'eth', 8, 2, 'oxteth');
INSERT INTO `symbol` VALUES (606, 'oxt', 'usdt', 4, 4, 'oxtusdt');
INSERT INTO `symbol` VALUES (607, 'pai', 'btc', 10, 2, 'paibtc');
INSERT INTO `symbol` VALUES (608, 'pai', 'eth', 8, 4, 'paieth');
INSERT INTO `symbol` VALUES (609, 'pai', 'usdt', 6, 4, 'paiusdt');
INSERT INTO `symbol` VALUES (610, 'pax', 'husd', 4, 4, 'paxhusd');
INSERT INTO `symbol` VALUES (611, 'pax', 'usdt', 4, 4, 'paxusdt');
INSERT INTO `symbol` VALUES (612, 'pay', 'btc', 8, 2, 'paybtc');
INSERT INTO `symbol` VALUES (613, 'pay', 'eth', 8, 2, 'payeth');
INSERT INTO `symbol` VALUES (614, 'pc', 'btc', 12, 2, 'pcbtc');
INSERT INTO `symbol` VALUES (615, 'pc', 'eth', 10, 4, 'pceth');
INSERT INTO `symbol` VALUES (616, 'pearl', 'btc', 4, 6, 'pearlbtc');
INSERT INTO `symbol` VALUES (617, 'pearl', 'eth', 4, 6, 'pearleth');
INSERT INTO `symbol` VALUES (618, 'pearl', 'usdt', 2, 6, 'pearlusdt');
INSERT INTO `symbol` VALUES (619, 'pha', 'btc', 10, 2, 'phabtc');
INSERT INTO `symbol` VALUES (620, 'pha', 'eth', 8, 2, 'phaeth');
INSERT INTO `symbol` VALUES (621, 'pha', 'usdt', 6, 4, 'phausdt');
INSERT INTO `symbol` VALUES (622, 'phx', 'btc', 10, 2, 'phxbtc');
INSERT INTO `symbol` VALUES (623, 'pnt', 'btc', 12, 2, 'pntbtc');
INSERT INTO `symbol` VALUES (624, 'pnt', 'eth', 10, 2, 'pnteth');
INSERT INTO `symbol` VALUES (625, 'pols', 'btc', 8, 2, 'polsbtc');
INSERT INTO `symbol` VALUES (626, 'pols', 'eth', 8, 2, 'polseth');
INSERT INTO `symbol` VALUES (627, 'pols', 'usdt', 4, 4, 'polsusdt');
INSERT INTO `symbol` VALUES (628, 'poly', 'btc', 8, 2, 'polybtc');
INSERT INTO `symbol` VALUES (629, 'poly', 'eth', 6, 4, 'polyeth');
INSERT INTO `symbol` VALUES (630, 'pond', 'btc', 10, 2, 'pondbtc');
INSERT INTO `symbol` VALUES (631, 'pond', 'eth', 8, 2, 'pondeth');
INSERT INTO `symbol` VALUES (632, 'pond', 'usdt', 6, 4, 'pondusdt');
INSERT INTO `symbol` VALUES (633, 'portal', 'btc', 10, 2, 'portalbtc');
INSERT INTO `symbol` VALUES (634, 'portal', 'eth', 8, 2, 'portaleth');
INSERT INTO `symbol` VALUES (635, 'powr', 'btc', 8, 0, 'powrbtc');
INSERT INTO `symbol` VALUES (636, 'powr', 'eth', 8, 0, 'powreth');
INSERT INTO `symbol` VALUES (637, 'propy', 'btc', 8, 2, 'propybtc');
INSERT INTO `symbol` VALUES (638, 'propy', 'eth', 8, 2, 'propyeth');
INSERT INTO `symbol` VALUES (639, 'pvt', 'btc', 10, 2, 'pvtbtc');
INSERT INTO `symbol` VALUES (640, 'pvt', 'ht', 8, 2, 'pvtht');
INSERT INTO `symbol` VALUES (641, 'pvt', 'usdt', 6, 2, 'pvtusdt');
INSERT INTO `symbol` VALUES (642, 'qash', 'btc', 8, 4, 'qashbtc');
INSERT INTO `symbol` VALUES (643, 'qash', 'eth', 6, 4, 'qasheth');
INSERT INTO `symbol` VALUES (644, 'qsp', 'btc', 8, 0, 'qspbtc');
INSERT INTO `symbol` VALUES (645, 'qsp', 'eth', 10, 0, 'qspeth');
INSERT INTO `symbol` VALUES (646, 'qtum', 'btc', 6, 4, 'qtumbtc');
INSERT INTO `symbol` VALUES (647, 'qtum', 'eth', 6, 4, 'qtumeth');
INSERT INTO `symbol` VALUES (648, 'qtum', 'husd', 4, 4, 'qtumhusd');
INSERT INTO `symbol` VALUES (649, 'qtum', 'usdt', 4, 4, 'qtumusdt');
INSERT INTO `symbol` VALUES (650, 'qun', 'btc', 10, 2, 'qunbtc');
INSERT INTO `symbol` VALUES (651, 'qun', 'eth', 8, 2, 'quneth');
INSERT INTO `symbol` VALUES (652, 'rbtc', 'btc', 6, 4, 'rbtcbtc');
INSERT INTO `symbol` VALUES (653, 'rccc', 'btc', 10, 2, 'rcccbtc');
INSERT INTO `symbol` VALUES (654, 'rccc', 'eth', 8, 4, 'rccceth');
INSERT INTO `symbol` VALUES (655, 'rcn', 'btc', 10, 0, 'rcnbtc');
INSERT INTO `symbol` VALUES (656, 'rcn', 'eth', 10, 0, 'rcneth');
INSERT INTO `symbol` VALUES (657, 'rdn', 'btc', 8, 0, 'rdnbtc');
INSERT INTO `symbol` VALUES (658, 'rdn', 'eth', 10, 0, 'rdneth');
INSERT INTO `symbol` VALUES (659, 'reef', 'btc', 10, 2, 'reefbtc');
INSERT INTO `symbol` VALUES (660, 'reef', 'eth', 8, 2, 'reefeth');
INSERT INTO `symbol` VALUES (661, 'reef', 'usdt', 6, 4, 'reefusdt');
INSERT INTO `symbol` VALUES (662, 'ren', 'btc', 8, 2, 'renbtc');
INSERT INTO `symbol` VALUES (663, 'renbtc', 'btc', 4, 4, 'renbtcbtc');
INSERT INTO `symbol` VALUES (664, 'renbtc', 'eth', 4, 4, 'renbtceth');
INSERT INTO `symbol` VALUES (665, 'ren', 'eth', 6, 4, 'reneth');
INSERT INTO `symbol` VALUES (666, 'ren', 'husd', 4, 4, 'renhusd');
INSERT INTO `symbol` VALUES (667, 'ren', 'usdt', 6, 2, 'renusdt');
INSERT INTO `symbol` VALUES (668, 'req', 'btc', 8, 1, 'reqbtc');
INSERT INTO `symbol` VALUES (669, 'req', 'eth', 8, 1, 'reqeth');
INSERT INTO `symbol` VALUES (670, 'ring', 'btc', 10, 2, 'ringbtc');
INSERT INTO `symbol` VALUES (671, 'ring', 'eth', 6, 2, 'ringeth');
INSERT INTO `symbol` VALUES (672, 'ring', 'usdt', 6, 2, 'ringusdt');
INSERT INTO `symbol` VALUES (673, 'rsr', 'btc', 10, 2, 'rsrbtc');
INSERT INTO `symbol` VALUES (674, 'rsr', 'ht', 6, 2, 'rsrht');
INSERT INTO `symbol` VALUES (675, 'rsr', 'husd', 6, 4, 'rsrhusd');
INSERT INTO `symbol` VALUES (676, 'rsr', 'usdt', 6, 2, 'rsrusdt');
INSERT INTO `symbol` VALUES (677, 'rte', 'btc', 10, 2, 'rtebtc');
INSERT INTO `symbol` VALUES (678, 'rte', 'eth', 8, 2, 'rteeth');
INSERT INTO `symbol` VALUES (679, 'ruff', 'btc', 10, 2, 'ruffbtc');
INSERT INTO `symbol` VALUES (680, 'ruff', 'eth', 8, 2, 'ruffeth');
INSERT INTO `symbol` VALUES (681, 'ruff', 'usdt', 6, 4, 'ruffusdt');
INSERT INTO `symbol` VALUES (682, 'rvn', 'btc', 10, 2, 'rvnbtc');
INSERT INTO `symbol` VALUES (683, 'rvn', 'ht', 6, 2, 'rvnht');
INSERT INTO `symbol` VALUES (684, 'rvn', 'usdt', 6, 2, 'rvnusdt');
INSERT INTO `symbol` VALUES (685, 'salt', 'btc', 10, 4, 'saltbtc');
INSERT INTO `symbol` VALUES (686, 'salt', 'eth', 8, 4, 'salteth');
INSERT INTO `symbol` VALUES (687, 'sand', 'btc', 8, 2, 'sandbtc');
INSERT INTO `symbol` VALUES (688, 'sand', 'ht', 6, 4, 'sandht');
INSERT INTO `symbol` VALUES (689, 'sand', 'usdt', 6, 4, 'sandusdt');
INSERT INTO `symbol` VALUES (690, 'sbtc', 'btc', 7, 4, 'sbtcbtc');
INSERT INTO `symbol` VALUES (691, 'sc', 'btc', 10, 2, 'scbtc');
INSERT INTO `symbol` VALUES (692, 'sc', 'eth', 8, 2, 'sceth');
INSERT INTO `symbol` VALUES (693, 'seele', 'btc', 10, 2, 'seelebtc');
INSERT INTO `symbol` VALUES (694, 'seele', 'eth', 8, 2, 'seeleeth');
INSERT INTO `symbol` VALUES (695, 'seele', 'usdt', 6, 2, 'seeleusdt');
INSERT INTO `symbol` VALUES (696, 'she', 'btc', 10, 2, 'shebtc');
INSERT INTO `symbol` VALUES (697, 'she', 'eth', 10, 2, 'sheeth');
INSERT INTO `symbol` VALUES (698, 'skl', 'btc', 8, 2, 'sklbtc');
INSERT INTO `symbol` VALUES (699, 'skl', 'eth', 8, 2, 'skleth');
INSERT INTO `symbol` VALUES (700, 'skl', 'usdt', 6, 4, 'sklusdt');
INSERT INTO `symbol` VALUES (701, 'skm', 'btc', 10, 2, 'skmbtc');
INSERT INTO `symbol` VALUES (702, 'skm', 'ht', 6, 2, 'skmht');
INSERT INTO `symbol` VALUES (703, 'skm', 'usdt', 6, 2, 'skmusdt');
INSERT INTO `symbol` VALUES (704, 'smt', 'btc', 10, 0, 'smtbtc');
INSERT INTO `symbol` VALUES (705, 'smt', 'eth', 8, 0, 'smteth');
INSERT INTO `symbol` VALUES (706, 'smt', 'usdt', 6, 4, 'smtusdt');
INSERT INTO `symbol` VALUES (707, 'snc', 'btc', 8, 2, 'sncbtc');
INSERT INTO `symbol` VALUES (708, 'snc', 'eth', 8, 2, 'snceth');
INSERT INTO `symbol` VALUES (709, 'snt', 'btc', 8, 0, 'sntbtc');
INSERT INTO `symbol` VALUES (710, 'snt', 'usdt', 6, 4, 'sntusdt');
INSERT INTO `symbol` VALUES (711, 'snx', 'btc', 8, 2, 'snxbtc');
INSERT INTO `symbol` VALUES (712, 'snx', 'eth', 6, 2, 'snxeth');
INSERT INTO `symbol` VALUES (713, 'snx', 'husd', 4, 2, 'snxhusd');
INSERT INTO `symbol` VALUES (714, 'snx', 'usdt', 4, 2, 'snxusdt');
INSERT INTO `symbol` VALUES (715, 'soc', 'btc', 10, 2, 'socbtc');
INSERT INTO `symbol` VALUES (716, 'soc', 'eth', 8, 2, 'soceth');
INSERT INTO `symbol` VALUES (717, 'soc', 'usdt', 6, 2, 'socusdt');
INSERT INTO `symbol` VALUES (718, 'sol', 'btc', 8, 2, 'solbtc');
INSERT INTO `symbol` VALUES (719, 'sol', 'eth', 6, 2, 'soleth');
INSERT INTO `symbol` VALUES (720, 'sol', 'usdt', 4, 2, 'solusdt');
INSERT INTO `symbol` VALUES (721, 'srn', 'btc', 10, 2, 'srnbtc');
INSERT INTO `symbol` VALUES (722, 'srn', 'eth', 8, 2, 'srneth');
INSERT INTO `symbol` VALUES (723, 'ssp', 'btc', 10, 2, 'sspbtc');
INSERT INTO `symbol` VALUES (724, 'ssp', 'eth', 10, 2, 'sspeth');
INSERT INTO `symbol` VALUES (725, 'steem', 'btc', 8, 2, 'steembtc');
INSERT INTO `symbol` VALUES (726, 'steem', 'eth', 6, 4, 'steemeth');
INSERT INTO `symbol` VALUES (727, 'steem', 'usdt', 4, 4, 'steemusdt');
INSERT INTO `symbol` VALUES (728, 'stk', 'btc', 10, 2, 'stkbtc');
INSERT INTO `symbol` VALUES (729, 'stk', 'eth', 8, 2, 'stketh');
INSERT INTO `symbol` VALUES (730, 'storj', 'btc', 8, 2, 'storjbtc');
INSERT INTO `symbol` VALUES (731, 'storj', 'usdt', 4, 4, 'storjusdt');
INSERT INTO `symbol` VALUES (732, 'stpt', 'btc', 8, 2, 'stptbtc');
INSERT INTO `symbol` VALUES (733, 'stpt', 'ht', 6, 2, 'stptht');
INSERT INTO `symbol` VALUES (734, 'stpt', 'usdt', 6, 2, 'stptusdt');
INSERT INTO `symbol` VALUES (735, 'sun', 'btc', 8, 2, 'sunbtc');
INSERT INTO `symbol` VALUES (736, 'sun', 'eth', 6, 4, 'suneth');
INSERT INTO `symbol` VALUES (737, 'sun', 'usdt', 4, 4, 'sunusdt');
INSERT INTO `symbol` VALUES (738, 'sushi', 'btc', 8, 2, 'sushibtc');
INSERT INTO `symbol` VALUES (739, 'sushi', 'eth', 6, 4, 'sushieth');
INSERT INTO `symbol` VALUES (740, 'sushi', 'husd', 4, 4, 'sushihusd');
INSERT INTO `symbol` VALUES (741, 'sushi', 'usdt', 4, 4, 'sushiusdt');
INSERT INTO `symbol` VALUES (742, 'swftc', 'btc', 10, 2, 'swftcbtc');
INSERT INTO `symbol` VALUES (743, 'swftc', 'eth', 8, 2, 'swftceth');
INSERT INTO `symbol` VALUES (744, 'swftc', 'usdt', 6, 2, 'swftcusdt');
INSERT INTO `symbol` VALUES (745, 'swrv', 'btc', 8, 2, 'swrvbtc');
INSERT INTO `symbol` VALUES (746, 'swrv', 'eth', 6, 4, 'swrveth');
INSERT INTO `symbol` VALUES (747, 'swrv', 'usdt', 4, 4, 'swrvusdt');
INSERT INTO `symbol` VALUES (748, 'theta', 'btc', 8, 2, 'thetabtc');
INSERT INTO `symbol` VALUES (749, 'theta', 'eth', 8, 2, 'thetaeth');
INSERT INTO `symbol` VALUES (750, 'theta', 'husd', 4, 4, 'thetahusd');
INSERT INTO `symbol` VALUES (751, 'theta', 'usdt', 4, 4, 'thetausdt');
INSERT INTO `symbol` VALUES (752, 'titan', 'btc', 8, 2, 'titanbtc');
INSERT INTO `symbol` VALUES (753, 'titan', 'eth', 8, 2, 'titaneth');
INSERT INTO `symbol` VALUES (754, 'titan', 'usdt', 6, 4, 'titanusdt');
INSERT INTO `symbol` VALUES (755, 'tnb', 'btc', 10, 0, 'tnbbtc');
INSERT INTO `symbol` VALUES (756, 'tnb', 'eth', 8, 0, 'tnbeth');
INSERT INTO `symbol` VALUES (757, 'tnb', 'usdt', 6, 2, 'tnbusdt');
INSERT INTO `symbol` VALUES (758, 'tnt', 'btc', 10, 0, 'tntbtc');
INSERT INTO `symbol` VALUES (759, 'tnt', 'eth', 8, 0, 'tnteth');
INSERT INTO `symbol` VALUES (760, 'top', 'btc', 10, 2, 'topbtc');
INSERT INTO `symbol` VALUES (761, 'topc', 'btc', 10, 2, 'topcbtc');
INSERT INTO `symbol` VALUES (762, 'topc', 'eth', 8, 2, 'topceth');
INSERT INTO `symbol` VALUES (763, 'top', 'ht', 6, 4, 'topht');
INSERT INTO `symbol` VALUES (764, 'top', 'usdt', 6, 4, 'topusdt');
INSERT INTO `symbol` VALUES (765, 'tos', 'btc', 10, 2, 'tosbtc');
INSERT INTO `symbol` VALUES (766, 'tos', 'eth', 8, 2, 'toseth');
INSERT INTO `symbol` VALUES (767, 'trb', 'btc', 6, 4, 'trbbtc');
INSERT INTO `symbol` VALUES (768, 'trb', 'eth', 6, 4, 'trbeth');
INSERT INTO `symbol` VALUES (769, 'trb', 'usdt', 4, 4, 'trbusdt');
INSERT INTO `symbol` VALUES (770, 'trio', 'btc', 10, 2, 'triobtc');
INSERT INTO `symbol` VALUES (771, 'trio', 'eth', 10, 2, 'trioeth');
INSERT INTO `symbol` VALUES (772, 'trx', 'btc', 10, 2, 'trxbtc');
INSERT INTO `symbol` VALUES (773, 'trx', 'eth', 8, 2, 'trxeth');
INSERT INTO `symbol` VALUES (774, 'trx', 'husd', 6, 4, 'trxhusd');
INSERT INTO `symbol` VALUES (775, 'trx', 'usdt', 6, 2, 'trxusdt');
INSERT INTO `symbol` VALUES (776, 'tt', 'btc', 10, 2, 'ttbtc');
INSERT INTO `symbol` VALUES (777, 'tt', 'ht', 6, 4, 'ttht');
INSERT INTO `symbol` VALUES (778, 'tt', 'usdt', 6, 2, 'ttusdt');
INSERT INTO `symbol` VALUES (779, 'tusd', 'husd', 4, 4, 'tusdhusd');
INSERT INTO `symbol` VALUES (780, 'uc', 'btc', 10, 2, 'ucbtc');
INSERT INTO `symbol` VALUES (781, 'uc', 'eth', 10, 2, 'uceth');
INSERT INTO `symbol` VALUES (782, 'ugas', 'btc', 10, 2, 'ugasbtc');
INSERT INTO `symbol` VALUES (783, 'ugas', 'eth', 7, 4, 'ugaseth');
INSERT INTO `symbol` VALUES (784, 'uip', 'btc', 10, 2, 'uipbtc');
INSERT INTO `symbol` VALUES (785, 'uip', 'eth', 8, 2, 'uipeth');
INSERT INTO `symbol` VALUES (786, 'uip', 'usdt', 6, 2, 'uipusdt');
INSERT INTO `symbol` VALUES (787, 'uma', 'btc', 6, 4, 'umabtc');
INSERT INTO `symbol` VALUES (788, 'uma', 'eth', 6, 4, 'umaeth');
INSERT INTO `symbol` VALUES (789, 'uma', 'usdt', 4, 4, 'umausdt');
INSERT INTO `symbol` VALUES (790, 'uni2l', 'usdt', 4, 4, 'uni2lusdt');
INSERT INTO `symbol` VALUES (791, 'uni2s', 'usdt', 6, 4, 'uni2susdt');
INSERT INTO `symbol` VALUES (792, 'uni', 'btc', 8, 2, 'unibtc');
INSERT INTO `symbol` VALUES (793, 'uni', 'eth', 6, 4, 'unieth');
INSERT INTO `symbol` VALUES (794, 'uni', 'husd', 4, 4, 'unihusd');
INSERT INTO `symbol` VALUES (795, 'uni', 'usdt', 4, 4, 'uniusdt');
INSERT INTO `symbol` VALUES (796, 'usdc', 'husd', 4, 4, 'usdchusd');
INSERT INTO `symbol` VALUES (797, 'usdc', 'usdt', 4, 4, 'usdcusdt');
INSERT INTO `symbol` VALUES (798, 'usdt', 'husd', 4, 4, 'usdthusd');
INSERT INTO `symbol` VALUES (799, 'utk', 'btc', 8, 2, 'utkbtc');
INSERT INTO `symbol` VALUES (800, 'utk', 'eth', 8, 2, 'utketh');
INSERT INTO `symbol` VALUES (801, 'utk', 'usdt', 4, 2, 'utkusdt');
INSERT INTO `symbol` VALUES (802, 'uuu', 'btc', 10, 2, 'uuubtc');
INSERT INTO `symbol` VALUES (803, 'uuu', 'eth', 10, 2, 'uuueth');
INSERT INTO `symbol` VALUES (804, 'uuu', 'usdt', 6, 2, 'uuuusdt');
INSERT INTO `symbol` VALUES (805, 'value', 'btc', 6, 4, 'valuebtc');
INSERT INTO `symbol` VALUES (806, 'value', 'eth', 6, 4, 'valueeth');
INSERT INTO `symbol` VALUES (807, 'value', 'usdt', 4, 4, 'valueusdt');
INSERT INTO `symbol` VALUES (808, 'ven', 'btc', 8, 2, 'venbtc');
INSERT INTO `symbol` VALUES (809, 'ven', 'eth', 8, 2, 'veneth');
INSERT INTO `symbol` VALUES (810, 'ven', 'usdt', 4, 4, 'venusdt');
INSERT INTO `symbol` VALUES (811, 'vet', 'btc', 10, 2, 'vetbtc');
INSERT INTO `symbol` VALUES (812, 'vet', 'eth', 8, 2, 'veteth');
INSERT INTO `symbol` VALUES (813, 'vet', 'husd', 6, 4, 'vethusd');
INSERT INTO `symbol` VALUES (814, 'vet', 'usdt', 6, 4, 'vetusdt');
INSERT INTO `symbol` VALUES (815, 'vidy', 'btc', 10, 2, 'vidybtc');
INSERT INTO `symbol` VALUES (816, 'vidy', 'ht', 6, 2, 'vidyht');
INSERT INTO `symbol` VALUES (817, 'vidy', 'usdt', 6, 2, 'vidyusdt');
INSERT INTO `symbol` VALUES (818, 'vsys', 'btc', 8, 2, 'vsysbtc');
INSERT INTO `symbol` VALUES (819, 'vsys', 'ht', 6, 2, 'vsysht');
INSERT INTO `symbol` VALUES (820, 'vsys', 'usdt', 4, 2, 'vsysusdt');
INSERT INTO `symbol` VALUES (821, 'wan', 'btc', 8, 2, 'wanbtc');
INSERT INTO `symbol` VALUES (822, 'wan', 'eth', 6, 4, 'waneth');
INSERT INTO `symbol` VALUES (823, 'waves', 'btc', 8, 4, 'wavesbtc');
INSERT INTO `symbol` VALUES (824, 'waves', 'eth', 6, 4, 'waveseth');
INSERT INTO `symbol` VALUES (825, 'waves', 'usdt', 4, 2, 'wavesusdt');
INSERT INTO `symbol` VALUES (826, 'waxp', 'btc', 8, 4, 'waxpbtc');
INSERT INTO `symbol` VALUES (827, 'waxp', 'eth', 6, 4, 'waxpeth');
INSERT INTO `symbol` VALUES (828, 'waxp', 'usdt', 6, 2, 'waxpusdt');
INSERT INTO `symbol` VALUES (829, 'wbtc', 'btc', 4, 4, 'wbtcbtc');
INSERT INTO `symbol` VALUES (830, 'wbtc', 'eth', 4, 4, 'wbtceth');
INSERT INTO `symbol` VALUES (831, 'wicc', 'btc', 8, 2, 'wiccbtc');
INSERT INTO `symbol` VALUES (832, 'wicc', 'eth', 8, 2, 'wicceth');
INSERT INTO `symbol` VALUES (833, 'wicc', 'usdt', 4, 4, 'wiccusdt');
INSERT INTO `symbol` VALUES (834, 'wnxm', 'btc', 6, 2, 'wnxmbtc');
INSERT INTO `symbol` VALUES (835, 'wnxm', 'eth', 6, 4, 'wnxmeth');
INSERT INTO `symbol` VALUES (836, 'wnxm', 'usdt', 4, 4, 'wnxmusdt');
INSERT INTO `symbol` VALUES (837, 'woo', 'btc', 8, 2, 'woobtc');
INSERT INTO `symbol` VALUES (838, 'woo', 'eth', 8, 2, 'wooeth');
INSERT INTO `symbol` VALUES (839, 'woo', 'usdt', 5, 2, 'woousdt');
INSERT INTO `symbol` VALUES (840, 'wpr', 'btc', 10, 2, 'wprbtc');
INSERT INTO `symbol` VALUES (841, 'wpr', 'eth', 8, 2, 'wpreth');
INSERT INTO `symbol` VALUES (842, 'wtc', 'btc', 8, 2, 'wtcbtc');
INSERT INTO `symbol` VALUES (843, 'wtc', 'eth', 6, 4, 'wtceth');
INSERT INTO `symbol` VALUES (844, 'wtc', 'usdt', 4, 4, 'wtcusdt');
INSERT INTO `symbol` VALUES (845, 'wxt', 'btc', 10, 2, 'wxtbtc');
INSERT INTO `symbol` VALUES (846, 'wxt', 'ht', 6, 2, 'wxtht');
INSERT INTO `symbol` VALUES (847, 'wxt', 'usdt', 6, 2, 'wxtusdt');
INSERT INTO `symbol` VALUES (848, 'xem', 'btc', 8, 2, 'xembtc');
INSERT INTO `symbol` VALUES (849, 'xem', 'usdt', 4, 4, 'xemusdt');
INSERT INTO `symbol` VALUES (850, 'xlm', 'btc', 8, 2, 'xlmbtc');
INSERT INTO `symbol` VALUES (851, 'xlm', 'eth', 6, 4, 'xlmeth');
INSERT INTO `symbol` VALUES (852, 'xlm', 'husd', 6, 4, 'xlmhusd');
INSERT INTO `symbol` VALUES (853, 'xlm', 'usdt', 6, 4, 'xlmusdt');
INSERT INTO `symbol` VALUES (854, 'xmr', 'btc', 6, 4, 'xmrbtc');
INSERT INTO `symbol` VALUES (855, 'xmr', 'eth', 6, 4, 'xmreth');
INSERT INTO `symbol` VALUES (856, 'xmr', 'usdt', 2, 4, 'xmrusdt');
INSERT INTO `symbol` VALUES (857, 'xmx', 'btc', 10, 2, 'xmxbtc');
INSERT INTO `symbol` VALUES (858, 'xmx', 'eth', 10, 2, 'xmxeth');
INSERT INTO `symbol` VALUES (859, 'xmx', 'usdt', 6, 2, 'xmxusdt');
INSERT INTO `symbol` VALUES (860, 'xrp3l', 'usdt', 4, 4, 'xrp3lusdt');
INSERT INTO `symbol` VALUES (861, 'xrp3s', 'usdt', 8, 4, 'xrp3susdt');
INSERT INTO `symbol` VALUES (862, 'xrp', 'btc', 9, 2, 'xrpbtc');
INSERT INTO `symbol` VALUES (863, 'xrp', 'ht', 6, 4, 'xrpht');
INSERT INTO `symbol` VALUES (864, 'xrp', 'husd', 4, 2, 'xrphusd');
INSERT INTO `symbol` VALUES (865, 'xrp', 'usdt', 5, 2, 'xrpusdt');
INSERT INTO `symbol` VALUES (866, 'xrt', 'btc', 6, 4, 'xrtbtc');
INSERT INTO `symbol` VALUES (867, 'xrt', 'eth', 6, 4, 'xrteth');
INSERT INTO `symbol` VALUES (868, 'xrt', 'usdt', 4, 4, 'xrtusdt');
INSERT INTO `symbol` VALUES (869, 'xtz', 'btc', 8, 2, 'xtzbtc');
INSERT INTO `symbol` VALUES (870, 'xtz', 'eth', 6, 4, 'xtzeth');
INSERT INTO `symbol` VALUES (871, 'xtz', 'husd', 4, 4, 'xtzhusd');
INSERT INTO `symbol` VALUES (872, 'xtz', 'usdt', 4, 4, 'xtzusdt');
INSERT INTO `symbol` VALUES (873, 'xvg', 'btc', 10, 2, 'xvgbtc');
INSERT INTO `symbol` VALUES (874, 'xvg', 'eth', 8, 2, 'xvgeth');
INSERT INTO `symbol` VALUES (875, 'yam', 'btc', 8, 4, 'yambtc');
INSERT INTO `symbol` VALUES (876, 'yam', 'eth', 6, 4, 'yameth');
INSERT INTO `symbol` VALUES (877, 'yam', 'usdt', 4, 4, 'yamusdt');
INSERT INTO `symbol` VALUES (878, 'yamv2', 'btc', 6, 4, 'yamv2btc');
INSERT INTO `symbol` VALUES (879, 'yamv2', 'eth', 6, 4, 'yamv2eth');
INSERT INTO `symbol` VALUES (880, 'yamv2', 'usdt', 4, 4, 'yamv2usdt');
INSERT INTO `symbol` VALUES (881, 'ycc', 'btc', 10, 2, 'yccbtc');
INSERT INTO `symbol` VALUES (882, 'ycc', 'eth', 8, 2, 'ycceth');
INSERT INTO `symbol` VALUES (883, 'yee', 'btc', 10, 2, 'yeebtc');
INSERT INTO `symbol` VALUES (884, 'yee', 'eth', 8, 2, 'yeeeth');
INSERT INTO `symbol` VALUES (885, 'yee', 'usdt', 6, 2, 'yeeusdt');
INSERT INTO `symbol` VALUES (886, 'yfi', 'btc', 4, 6, 'yfibtc');
INSERT INTO `symbol` VALUES (887, 'yfi', 'eth', 4, 6, 'yfieth');
INSERT INTO `symbol` VALUES (888, 'yfi', 'husd', 2, 6, 'yfihusd');
INSERT INTO `symbol` VALUES (889, 'yfii', 'btc', 6, 4, 'yfiibtc');
INSERT INTO `symbol` VALUES (890, 'yfii', 'eth', 6, 4, 'yfiieth');
INSERT INTO `symbol` VALUES (891, 'yfii', 'usdt', 4, 4, 'yfiiusdt');
INSERT INTO `symbol` VALUES (892, 'yfi', 'usdt', 2, 6, 'yfiusdt');
INSERT INTO `symbol` VALUES (893, 'zec3l', 'usdt', 4, 4, 'zec3lusdt');
INSERT INTO `symbol` VALUES (894, 'zec3s', 'usdt', 6, 4, 'zec3susdt');
INSERT INTO `symbol` VALUES (895, 'zec', 'btc', 6, 4, 'zecbtc');
INSERT INTO `symbol` VALUES (896, 'zec', 'husd', 2, 4, 'zechusd');
INSERT INTO `symbol` VALUES (897, 'zec', 'usdt', 2, 4, 'zecusdt');
INSERT INTO `symbol` VALUES (898, 'zen', 'btc', 8, 2, 'zenbtc');
INSERT INTO `symbol` VALUES (899, 'zen', 'eth', 6, 4, 'zeneth');
INSERT INTO `symbol` VALUES (900, 'zen', 'usdt', 4, 4, 'zenusdt');
INSERT INTO `symbol` VALUES (901, 'zil', 'btc', 10, 2, 'zilbtc');
INSERT INTO `symbol` VALUES (902, 'zil', 'eth', 8, 2, 'zileth');
INSERT INTO `symbol` VALUES (903, 'zil', 'husd', 6, 4, 'zilhusd');
INSERT INTO `symbol` VALUES (904, 'zil', 'usdt', 6, 4, 'zilusdt');
INSERT INTO `symbol` VALUES (905, 'zjlt', 'btc', 10, 2, 'zjltbtc');
INSERT INTO `symbol` VALUES (906, 'zjlt', 'eth', 8, 2, 'zjlteth');
INSERT INTO `symbol` VALUES (907, 'zks', 'btc', 8, 4, 'zksbtc');
INSERT INTO `symbol` VALUES (908, 'zks', 'eth', 8, 4, 'zkseth');
INSERT INTO `symbol` VALUES (909, 'zks', 'usdt', 4, 4, 'zksusdt');
INSERT INTO `symbol` VALUES (910, 'zla', 'btc', 10, 2, 'zlabtc');
INSERT INTO `symbol` VALUES (911, 'zla', 'eth', 10, 2, 'zlaeth');
INSERT INTO `symbol` VALUES (912, 'zrx', 'btc', 8, 2, 'zrxbtc');
INSERT INTO `symbol` VALUES (913, 'zrx', 'eth', 8, 2, 'zrxeth');
INSERT INTO `symbol` VALUES (914, 'zrx', 'husd', 4, 4, 'zrxhusd');
INSERT INTO `symbol` VALUES (915, 'zrx', 'usdt', 4, 2, 'zrxusdt');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `username` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `password` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `avatar` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `introduction` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `enable_mail` tinyint(1) NULL DEFAULT NULL,
  `send_mail` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `roles` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `is_delete` tinyint(1) NULL DEFAULT 0,
  `create_time` timestamp(3) NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', '123456', NULL, NULL, NULL, NULL, '[]', 0, '2021-03-03 15:02:33.299');

SET FOREIGN_KEY_CHECKS = 1;
