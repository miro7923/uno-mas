-- MySQL Script generated by MySQL Workbench
-- Sat Apr 30 16:48:29 2022
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema unomasdb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema unomasdb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `unomasdb` DEFAULT CHARACTER SET utf8 ;
USE `unomasdb` ;

-- -----------------------------------------------------
-- Table `unomasdb`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `unomasdb`.`users` (
  `user_num` INT NOT NULL AUTO_INCREMENT,
  `user_id` VARCHAR(20) NOT NULL,
  `user_pass` VARCHAR(16) NOT NULL,
  `user_name` VARCHAR(20) NOT NULL,
  `user_birth` VARCHAR(8) NOT NULL,
  `user_phone` VARCHAR(11) NOT NULL,
  `user_email` VARCHAR(100) NOT NULL,
  `user_postalcode` VARCHAR(10) NOT NULL,
  `user_roadaddr` VARCHAR(255) NOT NULL,
  `user_detailaddr` VARCHAR(255) NOT NULL,
  `user_regdate` TIMESTAMP NOT NULL DEFAULT now(),
  `user_status` INT NOT NULL DEFAULT 1 COMMENT '계정 활성화 상태인지 탈퇴 상태인지 휴면계정인지 표시용\n1:계정활성화(default)\n0: 휴면계정\n-1:탈퇴계정',
  `user_emailagree` TINYINT NULL DEFAULT 1 COMMENT '광고성 이메일 수신여부 표시\n자료형: boolean\n1: true(default)\n0: false',
  `user_point` INT NOT NULL DEFAULT 0,
  `user_use_point` TINYINT NULL DEFAULT 0 COMMENT '주문시 적립금을 항상 전액 사용할 것인지 여부를 저장하는 컬럼\n자료형: boolean\n0: false(default)\n1: true',
  `user_bank` VARCHAR(10) NULL COMMENT '환불요청시 입력받을 환불 계좌번호',
  `user_account` INT NULL COMMENT '‘-‘ 빼고 입력받기',
  `user_account_holder` VARCHAR(20) NULL,
  PRIMARY KEY (`user_num`),
  UNIQUE INDEX `user_id_UNIQUE` (`user_id` ASC) VISIBLE)
ENGINE = InnoDB
COMMENT = '회원정보 테이블\n한 명의 회원은 배송지 목록 테이블을 여러 개 가질 수 있다.\n한 명의 회원은 주문을 여러 개 가질 수 있다.\n한 명의 회원은 구매를 여러 개 가질 수 있다.\n한 명의 회원은 후기글을 여러 개 가질 수 있다.\n한 명의 회원은 여러 개의 장바구니 번호를 가질 수 있다.\n한 명의 회원은 여러 개의 위시리스트 번호를 가질 수 있다.';


-- -----------------------------------------------------
-- Table `unomasdb`.`top_category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `unomasdb`.`top_category` (
  `topcate_num` INT NOT NULL COMMENT '각 카테고리별로 순서대로 번호를 지정해서 넣어주기\nex. 1:채소, 2:과일, 3:유제품, …',
  `topcate_name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`topcate_num`),
  UNIQUE INDEX `topcate_name_UNIQUE` (`topcate_name` ASC) VISIBLE)
ENGINE = InnoDB
COMMENT = '상품 상위 카테고리';


-- -----------------------------------------------------
-- Table `unomasdb`.`detail_category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `unomasdb`.`detail_category` (
  `dcate_num` INT NOT NULL COMMENT '각 카테고리별로 순서대로 번호를 지정해서 넣어주기\nex. 1:채소, 2:과일, 3:유제품, …',
  `dcate_name` VARCHAR(100) NOT NULL,
  `topcate_num` INT NOT NULL,
  PRIMARY KEY (`dcate_num`),
  UNIQUE INDEX `dcate_name_UNIQUE` (`dcate_name` ASC) VISIBLE,
  INDEX `fk_topcate_num_idx` (`topcate_num` ASC) VISIBLE,
  CONSTRAINT `fk_dcate_topcate_num`
    FOREIGN KEY (`topcate_num`)
    REFERENCES `unomasdb`.`top_category` (`topcate_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '상품 하위 카테고리';


-- -----------------------------------------------------
-- Table `unomasdb`.`products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `unomasdb`.`products` (
  `prod_num` INT NOT NULL AUTO_INCREMENT,
  `prod_name` VARCHAR(15) NOT NULL,
  `prod_category` INT NOT NULL COMMENT '상품 하위 카테고리 인덱스 fk',
  `prod_price` INT NOT NULL,
  `prod_stock` INT NOT NULL COMMENT '이것은 최초의 재고임(절대값)\n실 재고는 prod_stock - prod_sellcnt 연산결과를 표시',
  `prod_thumbnail` VARCHAR(255) NULL COMMENT '상품 썸네일 이미지 파일',
  `prod_image1` VARCHAR(255) NULL COMMENT '상품 상세이미지 파일1',
  `prod_image2` VARCHAR(255) NULL COMMENT '상품 상세이미지 파일2',
  `prod_image3` VARCHAR(255) NULL COMMENT '상품 상세이미지 파일3',
  `prod_regdate` TIMESTAMP NOT NULL DEFAULT now() COMMENT '상품 등록일',
  `prod_expire` TIMESTAMP NOT NULL COMMENT '상품 유통기한',
  `prod_readcnt` INT NOT NULL DEFAULT 0 COMMENT '상품 게시글 조회수',
  `prod_sellcnt` INT NOT NULL DEFAULT 0 COMMENT '상품 판매량',
  `prod_keep` VARCHAR(20) NOT NULL COMMENT '상품 보관방법\nex. 냉동보관, 냉장보관, …',
  `prod_weight` INT NOT NULL COMMENT '상품 중량(g 단위)',
  `prod_country` VARCHAR(30) NOT NULL COMMENT '원산지\nex. 국산, 외국산, …',
  PRIMARY KEY (`prod_num`),
  UNIQUE INDEX `prod_name_UNIQUE` (`prod_name` ASC) VISIBLE,
  INDEX `fk_dcate_num_idx` (`prod_category` ASC) VISIBLE,
  CONSTRAINT `fk_prod_dcate_num`
    FOREIGN KEY (`prod_category`)
    REFERENCES `unomasdb`.`detail_category` (`dcate_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '상품 테이블은 여러 주문에 참고될 수 있다.\n상품 테이블은 여러 후기에 참고될 수 있다.';


-- -----------------------------------------------------
-- Table `unomasdb`.`board_review`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `unomasdb`.`board_review` (
  `review_num` INT NOT NULL AUTO_INCREMENT,
  `user_num` INT NOT NULL COMMENT '회원번호 fk',
  `prod_num` INT NOT NULL COMMENT '상품번호 fk',
  `review_title` VARCHAR(40) NOT NULL,
  `review_content` TEXT NOT NULL,
  `review_readcnt` INT NOT NULL DEFAULT 0,
  `review_regdate` TIMESTAMP NOT NULL DEFAULT now(),
  `review_ip` VARCHAR(255) NOT NULL,
  `review_image` VARCHAR(255) NULL COMMENT '후기와 함께 등록한 이미지 파일',
  `review_likecnt` INT NOT NULL DEFAULT 0 COMMENT '해당 리뷰가 받은 좋아요 개수',
  PRIMARY KEY (`review_num`),
  INDEX `fk_user_num_idx` (`user_num` ASC) VISIBLE,
  INDEX `fk_prod_num_idx` (`prod_num` ASC) VISIBLE,
  CONSTRAINT `fk_breview_user_num`
    FOREIGN KEY (`user_num`)
    REFERENCES `unomasdb`.`users` (`user_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_breview_prod_num`
    FOREIGN KEY (`prod_num`)
    REFERENCES `unomasdb`.`products` (`prod_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `unomasdb`.`order_addr`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `unomasdb`.`order_addr` (
  `addr_num` INT NOT NULL AUTO_INCREMENT,
  `user_num` INT NOT NULL,
  `addr_name` VARCHAR(10) NOT NULL COMMENT '주소지 별명',
  `addr_postalcode` VARCHAR(10) NOT NULL,
  `addr_roadaddr` VARCHAR(255) NOT NULL,
  `addr_detailaddr` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`addr_num`),
  INDEX `fk_user_num_idx` (`user_num` ASC) VISIBLE,
  CONSTRAINT `fk_oaddr_user_num`
    FOREIGN KEY (`user_num`)
    REFERENCES `unomasdb`.`users` (`user_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '회원의 배송지 목록을 저장할 테이블\nex. 집, 회사, …\n하나의 배송지 목록은 여러 주문에 참고될 수 있다.';


-- -----------------------------------------------------
-- Table `unomasdb`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `unomasdb`.`orders` (
  `order_code` INT NOT NULL AUTO_INCREMENT COMMENT '주문코드(상품번호와 복합키)',
  `user_num` INT NOT NULL,
  `prod_num` INT NOT NULL COMMENT '상품번호(주문번호와 복합키)',
  `order_date` TIMESTAMP NOT NULL DEFAULT now() COMMENT 'default: 주문이 생성되는 시점',
  `addr_num` INT NOT NULL COMMENT '주소북의 고유번호',
  `order_total` INT NOT NULL COMMENT '주문금액',
  `order_status` VARCHAR(10) NOT NULL COMMENT '입금완료, 배송중, 배송완료와 같은 상태',
  `order_quantity` INT NOT NULL COMMENT '상품 하나에 대한 주문수량',
  PRIMARY KEY (`order_code`, `prod_num`),
  INDEX `fk_prod_num_idx` (`prod_num` ASC) VISIBLE,
  INDEX `fk_user_num_idx` (`user_num` ASC) VISIBLE,
  INDEX `fk_order_addr_num_idx` (`addr_num` ASC) VISIBLE,
  UNIQUE INDEX `order_date_UNIQUE` (`order_date` ASC) VISIBLE,
  CONSTRAINT `fk_order_prod_num`
    FOREIGN KEY (`prod_num`)
    REFERENCES `unomasdb`.`products` (`prod_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_user_num`
    FOREIGN KEY (`user_num`)
    REFERENCES `unomasdb`.`users` (`user_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_order_addr_num`
    FOREIGN KEY (`addr_num`)
    REFERENCES `unomasdb`.`order_addr` (`addr_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '주문테이블\n주문 페이지에서 폼태그로 주문정보와 결제정보를 받아오는데\n백엔드단에서 DB 저장시에는 주문정보는 주문테이블을 불러와 저장하고\n결제정보는 결제테이블을 불러와서 저장한다.';


-- -----------------------------------------------------
-- Table `unomasdb`.`pay`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `unomasdb`.`pay` (
  `pay_num` INT NOT NULL AUTO_INCREMENT,
  `user_num` INT NOT NULL,
  `order_num` INT NOT NULL,
  `pay_date` TIMESTAMP NOT NULL DEFAULT now() COMMENT 'default: 결제 데이터가 생성되는 시점',
  `pay_method` VARCHAR(20) NOT NULL,
  `pay_bank` VARCHAR(20) NULL COMMENT '결제수단으로 무통장입금을 선택했을 시 사용',
  `pay_name` VARCHAR(20) NULL COMMENT '결제수단으로 무통장입금을 사용했을 시 예금주명',
  `pay_card_company` VARCHAR(20) NULL COMMENT '결제수단으로 신용카드를 선택했을 시 사용',
  `pay_card_num` INT NULL COMMENT '결제수단으로 신용카드를 선택했을 시 저장할 카드번호',
  PRIMARY KEY (`pay_num`),
  INDEX `fk_order_num_idx` (`order_num` ASC) VISIBLE,
  INDEX `fk_user_num_idx` (`user_num` ASC) VISIBLE,
  CONSTRAINT `fk_pay_order_num`
    FOREIGN KEY (`order_num`)
    REFERENCES `unomasdb`.`orders` (`order_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pay_user_num`
    FOREIGN KEY (`user_num`)
    REFERENCES `unomasdb`.`users` (`user_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '결제 정보를 가진 테이블\n주문 페이지에서 폼태그로 주문정보와 결제정보를 받아오는데\n백엔드단에서 DB 저장시에는 주문정보는 주문테이블을 불러와 저장하고\n결제정보는 결제테이블을 불러와서 저장한다.';


-- -----------------------------------------------------
-- Table `unomasdb`.`refund`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `unomasdb`.`refund` (
  `refund_num` INT NOT NULL AUTO_INCREMENT,
  `user_num` INT NOT NULL,
  `order_code` INT NOT NULL,
  `pay_num` INT NOT NULL,
  `refund_startdate` TIMESTAMP NOT NULL DEFAULT now() COMMENT 'default: 환불이 접수되어 해당 필드가 생성되는 시점',
  `refund_enddate` TIMESTAMP NULL COMMENT '환불 완료 일자',
  `refund_status` VARCHAR(10) NOT NULL DEFAULT '접수' COMMENT '환불 진행상태를 나타내는 컬럼\ndefault: 접수\n진행중 -> 완료 형식으로 바꾸기',
  PRIMARY KEY (`refund_num`),
  INDEX `fk_user_num_idx` (`user_num` ASC) VISIBLE,
  INDEX `fk_order_code_idx` (`order_code` ASC) VISIBLE,
  INDEX `fk_pay_num_idx` (`pay_num` ASC) VISIBLE,
  CONSTRAINT `fk_refund_user_num`
    FOREIGN KEY (`user_num`)
    REFERENCES `unomasdb`.`users` (`user_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_refund_order_code`
    FOREIGN KEY (`order_code`)
    REFERENCES `unomasdb`.`orders` (`order_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_refund_pay_num`
    FOREIGN KEY (`pay_num`)
    REFERENCES `unomasdb`.`pay` (`pay_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `unomasdb`.`change`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `unomasdb`.`change` (
  `change_num` INT NOT NULL AUTO_INCREMENT,
  `user_num` INT NOT NULL,
  `order_code` INT NOT NULL,
  `change_startdate` TIMESTAMP NOT NULL DEFAULT now(),
  `change_enddate` TIMESTAMP NULL,
  `change_status` VARCHAR(10) NOT NULL DEFAULT '접수' COMMENT '교환 진행 상태를 나타내는 컬럼\ndefault: 접수\n진행중 -> 완료 상태변화',
  PRIMARY KEY (`change_num`),
  INDEX `fk_user_num_idx` (`user_num` ASC) VISIBLE,
  INDEX `fk_order_code_idx` (`order_code` ASC) VISIBLE,
  CONSTRAINT `fk_change_user_num`
    FOREIGN KEY (`user_num`)
    REFERENCES `unomasdb`.`users` (`user_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_change_order_code`
    FOREIGN KEY (`order_code`)
    REFERENCES `unomasdb`.`orders` (`order_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '교환테이블';


-- -----------------------------------------------------
-- Table `unomasdb`.`deliveries`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `unomasdb`.`deliveries` (
  `deliv_num` INT NOT NULL AUTO_INCREMENT,
  `addr_num` INT NOT NULL,
  `order_num` INT NOT NULL,
  `user_num` INT NOT NULL,
  `deliv_regdate` TIMESTAMP NULL COMMENT '배송 시작일자\nnull 허용으로 뒀다가 배송 시작되면 날짜 변경하기',
  PRIMARY KEY (`deliv_num`),
  INDEX `fk_addr_num_idx` (`addr_num` ASC) VISIBLE,
  INDEX `fk_order_num_idx` (`order_num` ASC) VISIBLE,
  INDEX `fk_user_num_idx` (`user_num` ASC) VISIBLE,
  CONSTRAINT `fk_deliv_addr_num`
    FOREIGN KEY (`addr_num`)
    REFERENCES `unomasdb`.`order_addr` (`addr_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_deliv_order_num`
    FOREIGN KEY (`order_num`)
    REFERENCES `unomasdb`.`orders` (`order_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_deliv_user_num`
    FOREIGN KEY (`user_num`)
    REFERENCES `unomasdb`.`users` (`user_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '배송 테이블';


-- -----------------------------------------------------
-- Table `unomasdb`.`delivery_complete`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `unomasdb`.`delivery_complete` (
  `delivc_num` INT NOT NULL AUTO_INCREMENT,
  `deliv_num` INT NOT NULL COMMENT '배송번호 fk',
  `delivc_enddate` TIMESTAMP NOT NULL DEFAULT now() COMMENT '배송중이던 건이 배송 완료되면 배송 완료테이블에 등록\ndefault: 배송 완료 건수가 등록되는 시점',
  PRIMARY KEY (`delivc_num`),
  INDEX `fk_deliv_num_idx` (`deliv_num` ASC) VISIBLE,
  CONSTRAINT `fk_delivc_deliv_num`
    FOREIGN KEY (`deliv_num`)
    REFERENCES `unomasdb`.`deliveries` (`deliv_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '배송완료 테이블';


-- -----------------------------------------------------
-- Table `unomasdb`.`cart`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `unomasdb`.`cart` (
  `cart_num` INT NOT NULL AUTO_INCREMENT,
  `user_num` INT NOT NULL,
  `prod_num` INT NOT NULL,
  `prod_amount` INT NOT NULL DEFAULT 1 COMMENT '상품수량\ndefault: 1',
  PRIMARY KEY (`cart_num`),
  INDEX `fk_user_num_idx` (`user_num` ASC) VISIBLE,
  INDEX `fk_prod_num_idx` (`prod_num` ASC) VISIBLE,
  CONSTRAINT `fk_cart_user_num`
    FOREIGN KEY (`user_num`)
    REFERENCES `unomasdb`.`users` (`user_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cart_prod_num`
    FOREIGN KEY (`prod_num`)
    REFERENCES `unomasdb`.`products` (`prod_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '장바구니 테이블';


-- -----------------------------------------------------
-- Table `unomasdb`.`wishlist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `unomasdb`.`wishlist` (
  `wish_num` INT NOT NULL,
  `user_num` INT NOT NULL,
  `prod_num` INT NOT NULL,
  PRIMARY KEY (`wish_num`),
  INDEX `fk_user_num_idx` (`user_num` ASC) VISIBLE,
  INDEX `fk_prod_num_idx` (`prod_num` ASC) VISIBLE,
  CONSTRAINT `fk_wish_user_num`
    FOREIGN KEY (`user_num`)
    REFERENCES `unomasdb`.`users` (`user_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_wish_prod_num`
    FOREIGN KEY (`prod_num`)
    REFERENCES `unomasdb`.`products` (`prod_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '위시리스트 테이블';


-- -----------------------------------------------------
-- Table `unomasdb`.`admin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `unomasdb`.`admin` (
  `admin_num` INT NOT NULL,
  `admin_id` VARCHAR(10) NOT NULL,
  `admin_pass` VARCHAR(16) NOT NULL,
  `admin_permit` INT NOT NULL DEFAULT 2 COMMENT '관리자 권한\n1: 마스터(모든 권한)\n2: 회원문의에 답변만 가능(default)',
  `admin_regdate` TIMESTAMP NOT NULL COMMENT '관리자 입사일(혹은 계정 생성일)',
  `admin_lastlogin` TIMESTAMP NOT NULL DEFAULT now() COMMENT '마지막 로그인 날짜\n자바 코드 작성 시 관리자가 로그인 할 때 현재 시간으로 갱신되게 처리할 것!',
  PRIMARY KEY (`admin_num`))
ENGINE = InnoDB
COMMENT = '관리자 계정 테이블';


-- -----------------------------------------------------
-- Table `unomasdb`.`board_notice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `unomasdb`.`board_notice` (
  `notice_num` INT NOT NULL AUTO_INCREMENT,
  `admin_num` INT NOT NULL,
  `notice_title` VARCHAR(40) NOT NULL,
  `notice_content` MEDIUMTEXT NOT NULL,
  `notice_regdate` TIMESTAMP NOT NULL DEFAULT now(),
  `notice_readcnt` INT NOT NULL DEFAULT 0,
  `notice_ip` VARCHAR(255) NOT NULL,
  `notice_img` VARCHAR(255) NULL COMMENT '이미지 파일명',
  `notice_file` VARCHAR(255) NULL COMMENT '첨부파일명',
  PRIMARY KEY (`notice_num`),
  INDEX `fk_admin_num_idx` (`admin_num` ASC) VISIBLE,
  CONSTRAINT `fk_bnotice_admin_num`
    FOREIGN KEY (`admin_num`)
    REFERENCES `unomasdb`.`admin` (`admin_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `unomasdb`.`qna_category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `unomasdb`.`qna_category` (
  `qnacate_num` INT NOT NULL,
  `qnacate_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`qnacate_num`))
ENGINE = InnoDB
COMMENT = '고객센터용 질문 카테고리 테이블';


-- -----------------------------------------------------
-- Table `unomasdb`.`board_faq`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `unomasdb`.`board_faq` (
  `faq_num` INT NOT NULL AUTO_INCREMENT,
  `admin_num` INT NOT NULL,
  `faq_title` VARCHAR(40) NOT NULL,
  `faq_content` TEXT NOT NULL,
  `faq_regdate` TIMESTAMP NOT NULL DEFAULT now(),
  `qnacate_num` INT NOT NULL COMMENT '자주 묻는 질문을 정렬해서 보여줄 카테고리 번호\n회원 질문용 카테고리 테이블에서 읽어온다.',
  PRIMARY KEY (`faq_num`),
  INDEX `fk_admin_num_idx` (`admin_num` ASC) VISIBLE,
  INDEX `fk_qnacate_num_idx` (`qnacate_num` ASC) VISIBLE,
  CONSTRAINT `fk_bfaq_admin_num`
    FOREIGN KEY (`admin_num`)
    REFERENCES `unomasdb`.`admin` (`admin_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_bfaq_qnacate_num`
    FOREIGN KEY (`qnacate_num`)
    REFERENCES `unomasdb`.`qna_category` (`qnacate_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '자주 묻는 질문 테이블';


-- -----------------------------------------------------
-- Table `unomasdb`.`prod_inquiry`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `unomasdb`.`prod_inquiry` (
  `p_inquiry_num` INT NOT NULL AUTO_INCREMENT,
  `user_num` INT NOT NULL,
  `prod_num` INT NOT NULL,
  `p_inquiry_title` VARCHAR(40) NOT NULL,
  `p_inquiry_content` MEDIUMTEXT NOT NULL,
  `p_inquiry_regdate` TIMESTAMP NOT NULL DEFAULT now(),
  PRIMARY KEY (`p_inquiry_num`),
  INDEX `fk_user_num_idx` (`user_num` ASC) VISIBLE,
  INDEX `fk_prod_num_idx` (`prod_num` ASC) VISIBLE,
  CONSTRAINT `fk_pinq_user_num`
    FOREIGN KEY (`user_num`)
    REFERENCES `unomasdb`.`users` (`user_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pinq_prod_num`
    FOREIGN KEY (`prod_num`)
    REFERENCES `unomasdb`.`products` (`prod_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '상품 문의 게시판';


-- -----------------------------------------------------
-- Table `unomasdb`.`prod_comments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `unomasdb`.`prod_comments` (
  `com_num` INT NOT NULL AUTO_INCREMENT,
  `p_inquiry_num` INT NOT NULL,
  `admin_num` INT NOT NULL,
  `com_content` MEDIUMTEXT NOT NULL,
  `com_regdate` TIMESTAMP NOT NULL DEFAULT now(),
  PRIMARY KEY (`com_num`),
  INDEX `fk_p_inquiry_num_idx` (`p_inquiry_num` ASC) VISIBLE,
  INDEX `fk_admin_num_idx` (`admin_num` ASC) VISIBLE,
  CONSTRAINT `fk_pcom_p_inquiry_num`
    FOREIGN KEY (`p_inquiry_num`)
    REFERENCES `unomasdb`.`prod_inquiry` (`p_inquiry_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pcom_admin_num`
    FOREIGN KEY (`admin_num`)
    REFERENCES `unomasdb`.`admin` (`admin_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '상품 상세페이지에 있는 문의글 댓글테이블';


-- -----------------------------------------------------
-- Table `unomasdb`.`board_qna`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `unomasdb`.`board_qna` (
  `qna_num` INT NOT NULL AUTO_INCREMENT,
  `user_num` INT NOT NULL,
  `qna_title` VARCHAR(40) NOT NULL,
  `qna_content` MEDIUMTEXT NOT NULL,
  `qna_regdate` TIMESTAMP NOT NULL DEFAULT now(),
  `qnacate_num` INT NOT NULL COMMENT '고객문의 카테고리 번호\n고객문의 카테고리 테이블의 인덱스 번호를 fk로 가짐',
  `qna_process` TINYINT NOT NULL DEFAULT 0 COMMENT '답변 처리 여부\n0(default): 처리안됨(false)\n1: 처리완료(true)',
  PRIMARY KEY (`qna_num`),
  INDEX `fk_user_num_idx` (`user_num` ASC) VISIBLE,
  INDEX `fk_qnacate_num_idx` (`qnacate_num` ASC) VISIBLE,
  CONSTRAINT `fk_bqna_user_num`
    FOREIGN KEY (`user_num`)
    REFERENCES `unomasdb`.`users` (`user_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_bqna_qnacate_num`
    FOREIGN KEY (`qnacate_num`)
    REFERENCES `unomasdb`.`qna_category` (`qnacate_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '1:1 고객문의 게시판';


-- -----------------------------------------------------
-- Table `unomasdb`.`qna_comments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `unomasdb`.`qna_comments` (
  `qnacom_num` INT NOT NULL AUTO_INCREMENT,
  `qna_num` INT NOT NULL,
  `admin_num` INT NOT NULL,
  `qnacom_content` MEDIUMTEXT NOT NULL,
  `qnacom_regdate` TIMESTAMP NOT NULL DEFAULT now(),
  PRIMARY KEY (`qnacom_num`),
  INDEX `fk_qna_num_idx` (`qna_num` ASC) VISIBLE,
  INDEX `fk_admin_num_idx` (`admin_num` ASC) VISIBLE,
  CONSTRAINT `fk_qnacom_qna_num`
    FOREIGN KEY (`qna_num`)
    REFERENCES `unomasdb`.`board_qna` (`qna_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_qnacom_admin_num`
    FOREIGN KEY (`admin_num`)
    REFERENCES `unomasdb`.`admin` (`admin_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '1:1 고객문의에 대한 답변 테이블';

USE `unomasdb`;

DELIMITER $$
USE `unomasdb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `unomasdb`.`top_category_BEFORE_INSERT` BEFORE INSERT ON `top_category` FOR EACH ROW
BEGIN
IF
 new.topcate_name != '채소' and 
 new.topcate_name != '과일' and 
 new.topcate_name != '수산·해산·건어물' and 
 new.topcate_name != '정육·계란' and 
 new.topcate_name != '생수·우유·음료' 
THEN
 signal sqlstate 'ERROR' 
 set message_text = '*채소* *과일* *수산·해산·건어물* *정육·계란* *생수·우유·음료* 만 가능';
END IF;
END$$

USE `unomasdb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `unomasdb`.`refund_BEFORE_INSERT` BEFORE INSERT ON `refund` FOR EACH ROW
BEGIN
IF
 new.refund_status != '접수' and 
 new.refund_status != '진행중' and 
 new.refund_status != '완료' 
THEN
 signal sqlstate 'ERROR' set message_text = '*접수* *진행중* *완료* 만 가능';
END IF;
END$$

USE `unomasdb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `unomasdb`.`change_BEFORE_INSERT` BEFORE INSERT ON `change` FOR EACH ROW
BEGIN
IF
 new.change_status != '접수' and 
 new.change_status != '진행중' and 
 new.change_status != '완료' 
THEN
 signal sqlstate 'ERROR' 
 set message_text = '*접수* *진행중* *완료* 만 가능';
END IF;
END$$

USE `unomasdb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `unomasdb`.`qna_category_BEFORE_INSERT` BEFORE INSERT ON `qna_category` FOR EACH ROW
BEGIN
IF
 new.qnacate_name != '배송/포장' and 
 new.qnacate_name != '취소/교환/환불' and 
 new.qnacate_name != '이벤트/적립금' and 
 new.qnacate_name != '상품' and 
 new.qnacate_name != '주문/결제' and 
 new.qnacate_name != '회원' and 
 new.qnacate_name != '서비스 이용' 
THEN
 signal sqlstate 'ERROR' 
 set message_text = '*배송/포장* *취소/교환/환불* *이벤트/적립금* *상품* *주문/결제* *회원* *서비스 이용*';
END IF;
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
