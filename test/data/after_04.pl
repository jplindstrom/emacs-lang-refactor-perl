
sub parsePod {
    my $self = shift;
    my ($oLocation) = @_;

    my $rhPropertyTest = $oLocation->rhPropertyTest;

    my $key = "pod";
    $oLocation->rhProperty->{$key} = $pod;

    $oLocation->rhProperty->{$key}->whatevs;
}
