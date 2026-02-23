package db;

use DBI;
use Digest::MD5 qw(md5_hex);

my $dbh;

BEGIN {
    $dbh = DBI->connect("DBI:mysql:database=webtech;host=localhost", "root", "root");
};

sub getUserByLoginAndPassword {
    my $login = shift;
    my $password = shift;

    my $sql = "SELECT * FROM users WHERE login=? AND password=?";
    my $sth = $dbh->prepare($sql);
    $sth->execute($login, $password);
    my $row = $sth->fetchrow_hashref();

    return $row;
}

sub createSession {
    my $uid = shift;

    my $sessionId = md5_hex(time() . ':' . $uid);
    $dbh->do(
        "INSERT INTO sessions (created, user, session_id) VALUES (?, ?, ?)",
        undef,
        time(),
        $uid,
        $sessionId,
    ) or die $dbh->errstr;

    return $sessionId;
}

sub isSessionOK {
    my $sessionId = shift;

    my $sql = "SELECT * FROM sessions WHERE session_id=?";
    my $sth = $dbh->prepare($sql);
    $sth->execute($sessionId);

    my $now = time();
    my $isSessionOK = 0;
    while (my $row = $sth->fetchrow_hashref()) {
        if ($now - $row->{created} < 3600) {
            $isSessionOK = 1;
            last;
        }
    }

    return $isSessionOK;
}

sub getUserBySessionId {
    my $sessionId = shift;

    my $sql = "
        SELECT * FROM users AS u, sessions AS s
        WHERE s.session_id=? AND u.uid = s.user
    ";
    my $sth = $dbh->prepare($sql);
    $sth->execute($sessionId);
    my $row = $sth->fetchrow_hashref();

    return $row;
}

sub dropSession {
    my $sessionId = shift;

    my $sql = "DELETE FROM sessions WHERE session_id=?";
    my $sth = $dbh->prepare($sql);
    $sth->execute($sessionId) or die $dbh->errstr;
}

sub createUser {
    my $data = shift;

    $dbh->do(
        "
            INSERT INTO users 
            (login, password, email, firstname, lastname, position)
            VALUES (?, ?, ?, ?, ?, ?)
        ",
        undef,
        $data->{login},
        $data->{password},
        $data->{email},
        $data->{firstname},
        $data->{lastname},
        $data->{position},
    ) or return 0;

    return 1;
}

sub getUserIdBySessionId {
    my $sessionId = shift;

    my $sql = "
        SELECT user FROM sessions WHERE session_id=?
    ";
    my $sth = $dbh->prepare($sql);
    $sth->execute($sessionId);
    my $row = $sth->fetchrow_hashref();

    return $row->{user};
}

sub updateUser {
    my $data = shift;

    $dbh->do(
        "
            UPDATE users 
            SET email=?, firstname=?, lastname=?, position=?
            WHERE uid=?
        ",
        undef,
        $data->{email},
        $data->{firstname},
        $data->{lastname},
        $data->{position},
        $data->{uid},
    );

    if ($data->{password}) {
        $dbh->do(
            "UPDATE users SET password=? WHERE uid=?",
            undef,
            $data->{password},
            $data->{uid},
        );
    }
}

sub createTask {
    my $uid = shift;
    my $data = shift;

    $dbh->do(
        "
            INSERT INTO tasks 
            (created, user, data)
            VALUES (?, ?, ?)
        ",
        undef,
        time(),
        $uid,
        $data,
    ) or return 0;
}

sub getAllTasksForUser {
    my $uid = shift;

    my $sql = "SELECT * FROM tasks WHERE user=?";
    my $sth = $dbh->prepare($sql);
    $sth->execute($uid);

    return $sth->fetchall_arrayref({});
}

1;