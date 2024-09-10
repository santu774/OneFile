-- 创建分区的用户表
CREATE TABLE User (
                      user_id INT PRIMARY KEY,
                      user_name VARCHAR(255),
                      user_type VARCHAR(255),
                      create_time TIMESTAMP,
                      used_space INT
) PARTITION BY RANGE (user_id) (
    PARTITION p0 VALUES LESS THAN (1000),  -- 假设分区界限
    PARTITION p1 VALUES LESS THAN (2000),
    PARTITION p2 VALUES LESS THAN MAXVALUE  -- 最后一个分区包含剩余的所有值
);

-- 创建分区的逻辑文件表
CREATE TABLE Logic_File (
                            logic_file_id INT PRIMARY KEY,
                            user_id INT,  -- 假设PK是用户表的外键
                            file_name VARCHAR(255),
                            is_directory BOOLEAN,
                            create_time TIMESTAMP,
                            parent_file_id INT,
                            md5 CHAR(32),
                            size INT,
                            FOREIGN KEY (user_id) REFERENCES User(user_id)
) PARTITION BY RANGE (user_id) (
    PARTITION p0 VALUES LESS THAN (1000),
    PARTITION p1 VALUES LESS THAN (2000),
    PARTITION p2 VALUES LESS THAN MAXVALUE
);
-- 创建分区的物理文件表
CREATE TABLE Physics_File (
                              file_id INT PRIMARY KEY,
                              user_id INT,
                              block_id INT,
                              is_shared BOOLEAN,
                              md5 CHAR(32),
                              size INT,
                              create_time TIMESTAMP,
                              FOREIGN KEY (user_id) REFERENCES User(user_id)
) PARTITION BY RANGE (file_id) (  -- 假设按照file_id分区
    PARTITION p0 VALUES LESS THAN (1000),
    PARTITION p1 VALUES LESS THAN (2000),
    PARTITION p2 VALUES LESS THAN MAXVALUE
);
-- 创建分区的区块表
CREATE TABLE Block (
                       block_id INT PRIMARY KEY,
                       file_id INT,
                       md5 CHAR(32),
                       `256kmd5` CHAR(32),
                       size INT,
                       create_time TIMESTAMP,
                       FOREIGN KEY (file_id) REFERENCES Physics_File(file_id)
) PARTITION BY RANGE (file_id) (  -- 假设按照file_id分区
    PARTITION p0 VALUES LESS THAN (1000),
    PARTITION p1 VALUES LESS THAN (2000),
    PARTITION p2 VALUES LESS THAN MAXVALUE
);