#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: funcgen.pl
#
#        USAGE: ./funcgen.pl <chr> 
#
#  DESCRIPTION: Tool to retrive regulatory feature regions of given chromosome
#
# REQUIREMENTS: BioPerl, EnsEMBL
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Mutharasu Gnanavel 
# ORGANIZATION: University of Tampere
#      VERSION: 1.0
#      CREATED: 03/14/2016 03:35:44 PM
#     REVISION: ---
#===============================================================================

#use strict;
use warnings;
use utf8;
use Bio::EnsEMBL::Registry;

my $chr = $ARGV[0];
my $registry = 'Bio::EnsEMBL::Registry';

$registry->load_registry_from_db(
    -host => 'ensembldb.ensembl.org',
    -user => 'anonymous'); 

my $regfeat_adaptor = $registry->get_adaptor('Human', 'Funcgen', 'RegulatoryFeature');
my $slice_adaptor   = $registry->get_adaptor('Human', 'Core', 'Slice');

my $slice = $slice_adaptor->fetch_by_region('chromosome', $chr); #,54960000,54980000);

my @reg_feats = @{$regfeat_adaptor->fetch_all_by_Slice($slice)};

foreach my $rf(@reg_feats){
        print $rf->stable_id.": ";
        print_feature($rf);
#        print "\tCell: ".$rf->cell_type->name."\n";
#        print "\t Feature Type: ".$rf->feature_type->name."\n";
}

sub print_feature{
    my $feature = shift;
    print $feature->display_label.
                    "\t(".$feature->seq_region_name.":".
                    $feature->seq_region_start."-".
                    $feature->seq_region_end.")\n";
}

foreach my $feature (@{$rf->regulatory_attributes()}){
        print_feature($feature);
}
