DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `sessions`;

CREATE TABLE users (
    `uid` int NOT NULL AUTO_INCREMENT,
    `login` varchar(100) NOT NULL,
    `password` varchar(100) NOT NULL,
    `email` varchar(100),
    `firstname` varchar(100),
    `lastname` varchar(100),
    `position` varchar(100),

    PRIMARY KEY (uid),
    UNIQUE (login)
);

INSERT INTO users
(`login`, `password`, `email`, `firstname`, `lastname`, `position`)
VALUES
('denis', '123', 'denis@example.com', 'Denys', 'Bushtruk', 'Author')
;

INSERT INTO users
(`login`, `password`, `email`, `firstname`, `lastname`, `position`)
VALUES
('alex', '123', 'alex@example.com', 'Alex', 'Artukh', 'Another author')
;

CREATE TABLE sessions (
    `sid` int NOT NULL AUTO_INCREMENT,
    `created` int NOT NULL,
    `user` int NOT NULL,
    `session_id` varchar(32) NOT NULL,

    PRIMARY KEY (sid)
);
