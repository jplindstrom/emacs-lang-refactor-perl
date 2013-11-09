
sub parsePod {
    my $self = shift;
    my ($oLocation) = @_;

    my $rhPropertyTest = $oLocation->rhPropertyTest;

    my $rhProperty = $oLocation->rhProperty;
    $rhProperty->{pod} = $pod;
}
