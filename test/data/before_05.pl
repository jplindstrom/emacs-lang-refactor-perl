
sub parsePod {
    my $self = shift;
    my ($oLocation) = @_;

    my $rhPropertyTest = $oLocation->rhPropertyTest;

    $oLocation->rhProperty->{$abc{def}} = $pod;

    $oLocation->rhProperty->{$abc{def}}->whatevs;
}
