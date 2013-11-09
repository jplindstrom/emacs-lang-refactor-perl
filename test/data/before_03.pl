
sub parsePod {
    my $self = shift;
    my ($oLocation) = @_;

    my $rhPropertyTest = $oLocation->rhPropertyTest;

    $oLocation->rhProperty->{pod} = $pod;
}
