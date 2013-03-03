
# Won't be touched by normal extract variable
sub otherSub {
    my $self = shift;
    my ($oLocation) = @_;
    $oLocation->rhProperty->{pod} = "=head1 SYNOPSIS";
}

# Just random stuff outside the sub
$oLocation->rhProperty->{pod} = "POD";

sub parsePod {
    my $self = shift;
    my ($oLocation) = @_;

    my $pod = "POD";

    $oLocation->rhProperty->{pod} = $pod;

    say "hello\n";

    $oLocation->rhProperty->{pod} = $pod;
    $oLocation->rhProperty->{podSection} = $podSection;

    say "there\n";
}
