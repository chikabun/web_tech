package db;

use DBI;

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

    $dbh->do(
        sprintf "INSERT INTO sessions (created, user) VALUES (%s, %s)", time(), $uid
    ) or die $dbh->errstr;
}

sub isSessionOK {
    my $userid = shift;

    my $sql = "SELECT * FROM sessions WHERE user=?";
    my $sth = $dbh->prepare($sql);
    $sth->execute($userid);

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

sub getUser {
    my $userid = shift;

    my $sql = "SELECT * FROM users WHERE uid=?";
    my $sth = $dbh->prepare($sql);
    $sth->execute($userid);
    my $row = $sth->fetchrow_hashref();

    return $row;
}

sub dropSession {
    my $user = shift;

    my $sql = "DELETE FROM sessions WHERE user=?";
    my $sth = $dbh->prepare($sql);
    $sth->execute($user) or die $dbh->errstr;
}

1;