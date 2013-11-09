
# Won't be touched by normal extract variable
sub otherSub {
    my $self = shift;
    my ($oLocation) = @_;
    my $rhProperty = $oLocation->rhProperty;
    $rhProperty->{pod} = "=head1 SYNOPSIS";
}

# Just random stuff outside the sub
$rhProperty->{pod} = "POD";

sub parsePod {
    my $self = shift;
    my ($oLocation) = @_;

    my $pod = "POD";

    $rhProperty->{pod} = $pod;

    say "hello\n";

    $rhProperty->{pod} = $pod;
    $rhProperty->{podSection} = $podSection;

    say "there\n";
}
