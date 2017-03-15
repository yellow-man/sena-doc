-- -----------------------------------------------------
-- Table `sena_db`.`stock_prices`
-- -----------------------------------------------------
ALTER TABLE `sena_db`.`stock_prices` 
	CHANGE COLUMN `opening_price` `opening_price` DECIMAL(20,5) NULL COMMENT '始値	（整数部：15桁、小数部：5桁）' ,
	CHANGE COLUMN `high_price` `high_price` DECIMAL(20,5) NULL COMMENT '高値	（整数部：15桁、小数部：5桁）' ,
	CHANGE COLUMN `low_price` `low_price` DECIMAL(20,5) NULL COMMENT '安値	（整数部：15桁、小数部：5桁）' ,
	CHANGE COLUMN `closing_price` `closing_price` DECIMAL(20,5) NULL COMMENT '終値	（整数部：15桁、小数部：5桁）' ,
	CHANGE COLUMN `turnover` `turnover` DECIMAL(20,5) NULL COMMENT '出来高	（整数部：15桁、小数部：5桁）' ,
	CHANGE COLUMN `adjusted_closing_price` `adjusted_closing_price` DECIMAL(20,5) NULL COMMENT '調整後終値	（分割実施前の終値を分割後の値に調整したもの、整数部：15桁、小数部：5桁）' ;
