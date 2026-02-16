/*
CREATE TABLE users (
    uid int NOT NULL AUTO_INCREMENT,
    login varchar(100) NOT NULL,
    password varchar(100) NOT NULL,
    email varchar(100),
    firstname varchar(100),
    lastname varchar(100),
    position varchar(100),

    PRIMARY KEY (uid)
);
*/

CREATE TABLE sessions (
    sid int NOT NULL AUTO_INCREMENT,
    created int NOT NULL,
    user int NOT NULL,

    PRIMARY KEY (sid)
);
