-- MySQL Script generated by MySQL Workbench
-- Wed Mar  8 23:50:46 2017
-- Model: sena_ERD    Version: sena-core-1.2.0
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema sena_db
-- -----------------------------------------------------
-- マスタ関連
CREATE SCHEMA IF NOT EXISTS `sena_db` DEFAULT CHARACTER SET utf8mb4 ;
-- -----------------------------------------------------
-- Schema sena_secure_db
-- -----------------------------------------------------
-- ユーザー関連
USE `sena_db` ;

-- -----------------------------------------------------
-- Table `sena_db`.`stocks`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sena_db`.`stocks` ;

CREATE TABLE IF NOT EXISTS `sena_db`.`stocks` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '銘柄ID',
  `date` DATE NOT NULL COMMENT '取得日',
  `stock_code` INT NOT NULL COMMENT '銘柄コード',
  `stock_name` VARCHAR(128) NOT NULL COMMENT '銘柄名',
  `market` VARCHAR(64) NULL COMMENT '市場名',
  `topix_sector` VARCHAR(64) NULL COMMENT '業種分類',
  `share_unit` INT NULL COMMENT '単元株数	（単元制度なし：-1）',
  `nikkei225_flg` TINYINT(1) NULL DEFAULT 0 COMMENT '日経225採用銘柄フラグ	（1：採用銘柄、0：未採用銘柄）',
  `created` DATETIME NOT NULL COMMENT '作成日時',
  `modified` DATETIME NOT NULL COMMENT '更新日時',
  `delete_flg` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '削除フラグ	（1：削除、0：未削除）',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = '銘柄';

CREATE INDEX `i_stocks1` ON `sena_db`.`stocks` (`delete_flg` ASC, `date` ASC, `stock_code` ASC);


-- -----------------------------------------------------
-- Table `sena_db`.`company_schedules`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sena_db`.`company_schedules` ;

CREATE TABLE IF NOT EXISTS `sena_db`.`company_schedules` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '企業スケジュールID',
  `settlement_date` DATE NOT NULL COMMENT '決算発表日',
  `stock_code` INT NOT NULL COMMENT '銘柄コード',
  `settlement` VARCHAR(64) NOT NULL COMMENT '決算期	（サンプル：4月期、12月期）',
  `settlement_types_id` INT NOT NULL COMMENT '決算種別	（サンプル：1..第１、2..第２、3..第３、4..本）',
  `reg_calendar_flg` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'カレンダー登録済みフラグ	（1：登録済み、0：未登録）',
  `created` DATETIME NOT NULL COMMENT '作成日時',
  `modified` DATETIME NOT NULL COMMENT '更新日時',
  `delete_flg` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '削除フラグ	（1：削除、0：未削除）',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = '企業スケジュール';

CREATE INDEX `fk_company_schedules_stocks_idx` ON `sena_db`.`company_schedules` (`stock_code` ASC);

CREATE UNIQUE INDEX `uk_company_schedules` ON `sena_db`.`company_schedules` (`settlement_date` ASC, `stock_code` ASC);

CREATE INDEX `i_company_schedules1` ON `sena_db`.`company_schedules` (`delete_flg` ASC, `settlement_date` ASC, `stock_code` ASC);

CREATE INDEX `i_company_schedules2` ON `sena_db`.`company_schedules` (`delete_flg` ASC, `stock_code` ASC, `settlement_date` ASC);

CREATE INDEX `i_company_schedules3` ON `sena_db`.`company_schedules` (`delete_flg` ASC, `reg_calendar_flg` ASC);


-- -----------------------------------------------------
-- Table `sena_db`.`debit_balances`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sena_db`.`debit_balances` ;

CREATE TABLE IF NOT EXISTS `sena_db`.`debit_balances` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '信用残ID',
  `release_date` DATE NOT NULL COMMENT '公表日',
  `stock_code` INT NOT NULL COMMENT '銘柄コード',
  `margin_selling_balance` INT NOT NULL COMMENT '信用売残	（ハイフン等、数値に変換できない場合：-1）',
  `margin_debt_balance` INT NOT NULL COMMENT '信用買残	（ハイフン等、数値に変換できない場合：-1）',
  `ratio_margin_balance` DECIMAL(10,2) NOT NULL COMMENT '信用倍率	（整数部：8桁、小数部：2桁、ハイフン等、数値に変換できない場合：-1）',
  `created` DATETIME NOT NULL COMMENT '作成日時',
  `modified` DATETIME NOT NULL COMMENT '更新日時',
  `delete_flg` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '削除フラグ	（1：削除、0：未削除）',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = '信用残';

CREATE INDEX `fk_debit_balances_stocks1_idx` ON `sena_db`.`debit_balances` (`stock_code` ASC);

CREATE UNIQUE INDEX `uk_debit_balances` ON `sena_db`.`debit_balances` (`release_date` ASC, `stock_code` ASC);

CREATE INDEX `i_debit_balances1` ON `sena_db`.`debit_balances` (`delete_flg` ASC, `release_date` ASC, `stock_code` ASC);

CREATE INDEX `i_debit_balances2` ON `sena_db`.`debit_balances` (`delete_flg` ASC, `stock_code` ASC, `release_date` ASC);


-- -----------------------------------------------------
-- Table `sena_db`.`indicators`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sena_db`.`indicators` ;

CREATE TABLE IF NOT EXISTS `sena_db`.`indicators` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '指標ID',
  `date` DATE NOT NULL COMMENT '取得日',
  `stock_code` INT NOT NULL COMMENT '銘柄コード',
  `dividend_yield` DECIMAL(10,2) NULL COMMENT '配当利回り	（整数部：8桁、小数部：2桁）',
  `price_earnings_ratio` DECIMAL(10,2) NULL COMMENT '株価収益率	（PER、整数部：8桁、小数部：2桁）',
  `price_book_value_ratio` DECIMAL(10,2) NULL COMMENT '株価純資産倍率	（PBR、整数部：8桁、小数部：2桁）',
  `earnings_per_share` DECIMAL(10,2) NULL COMMENT '1株利益	（EPS、整数部：8桁、小数部：2桁）',
  `book_value_per_share` DECIMAL(10,2) NULL COMMENT '1株当たり純資産	（BPS、整数部：8桁、小数部：2桁）',
  `return_on_equity` DECIMAL(25,20) NULL COMMENT '株主資本利益率	（ROE、整数部：5桁、小数部：20桁）',
  `capital_ratio` DECIMAL(10,2) NULL COMMENT '自己資本比率	（整数部：8桁、小数部：2桁）',
  `created` DATETIME NOT NULL COMMENT '作成日時',
  `modified` DATETIME NOT NULL COMMENT '更新日時',
  `delete_flg` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '削除フラグ	（1：削除、0：未削除）',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = '指標';

CREATE INDEX `fk_debit_balances_copy1_stocks1_idx` ON `sena_db`.`indicators` (`stock_code` ASC);

CREATE UNIQUE INDEX `uk_indicators` ON `sena_db`.`indicators` (`date` ASC, `stock_code` ASC);

CREATE INDEX `i_indicators1` ON `sena_db`.`indicators` (`delete_flg` ASC, `date` ASC, `stock_code` ASC);


-- -----------------------------------------------------
-- Table `sena_db`.`finances`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sena_db`.`finances` ;

CREATE TABLE IF NOT EXISTS `sena_db`.`finances` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '財務ID',
  `year` INT NOT NULL COMMENT '決算年',
  `settlement_types_id` INT NOT NULL COMMENT '決算種別	（サンプル：1..第１、2..第２、3..第３、4..本）',
  `stock_code` INT NOT NULL COMMENT '銘柄コード',
  `sales` INT NULL COMMENT '売上高',
  `operating_profit` INT NULL COMMENT '営業益',
  `net_profit` INT NULL COMMENT '純利益',
  `sales_rate` DECIMAL(30,20) NULL COMMENT '売上高	（前年比、整数部：10桁、小数部：20桁）',
  `operating_profit_rate` DECIMAL(30,20) NULL COMMENT '営業益	（前年比、整数部：10桁、小数部：20桁）',
  `net_profit_rate` DECIMAL(30,20) NULL COMMENT '純利益	（前年比、整数部：10桁、小数部：20桁）',
  `created` DATETIME NOT NULL COMMENT '作成日時',
  `modified` DATETIME NOT NULL COMMENT '更新日時',
  `delete_flg` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '削除フラグ	（1：削除、0：未削除）',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = '財務';

CREATE INDEX `fk_finances_stocks1_idx` ON `sena_db`.`finances` (`stock_code` ASC);

CREATE UNIQUE INDEX `uk_finances` ON `sena_db`.`finances` (`year` ASC, `settlement_types_id` ASC, `stock_code` ASC);

CREATE INDEX `i_finances1` ON `sena_db`.`finances` (`delete_flg` ASC, `year` ASC, `settlement_types_id` ASC, `stock_code` ASC);

CREATE INDEX `i_finances2` ON `sena_db`.`finances` (`delete_flg` ASC, `stock_code` ASC, `year` ASC, `settlement_types_id` ASC);

CREATE INDEX `i_finances3` ON `sena_db`.`finances` (`delete_flg` ASC, `stock_code` ASC, `settlement_types_id` ASC);


-- -----------------------------------------------------
-- Table `sena_db`.`stock_prices`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sena_db`.`stock_prices` ;

CREATE TABLE IF NOT EXISTS `sena_db`.`stock_prices` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '株価ID',
  `date` DATE NOT NULL COMMENT '日付',
  `stock_code` INT NOT NULL COMMENT '銘柄コード',
  `opening_price` DECIMAL(20,5) NOT NULL COMMENT '始値	（整数部：15桁、小数部：5桁）',
  `high_price` DECIMAL(20,5) NOT NULL COMMENT '高値	（整数部：15桁、小数部：5桁）',
  `low_price` DECIMAL(20,5) NOT NULL COMMENT '安値	（整数部：15桁、小数部：5桁）',
  `closing_price` DECIMAL(20,5) NOT NULL COMMENT '終値	（整数部：15桁、小数部：5桁）',
  `turnover` DECIMAL(20,5) NOT NULL COMMENT '出来高	（整数部：15桁、小数部：5桁）',
  `adjusted_closing_price` DECIMAL(20,5) NOT NULL COMMENT '調整後終値	（分割実施前の終値を分割後の値に調整したもの、整数部：15桁、小数部：5桁）',
  `created` DATETIME NOT NULL COMMENT '作成日時',
  `modified` DATETIME NOT NULL COMMENT '更新日時',
  `delete_flg` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '削除フラグ	（1：削除、0：未削除）',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = '株価';

CREATE INDEX `i_stock_prices1` ON `sena_db`.`stock_prices` (`date` ASC, `stock_code` ASC);

CREATE INDEX `i_stock_prices2` ON `sena_db`.`stock_prices` (`stock_code` ASC, `date` ASC);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
