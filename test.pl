use 5.38.0;

BEGIN {
    eval q{
    package MyClass::Moose;
    use Moose;

    has 'attribute1' => (is => 'ro');
    has 'attribute2' => (is => 'ro');
    has 'attribute3' => (is => 'ro');

    MyClass::Moose->meta->make_immutable;
    } if ($ENV{MOOSE});

    eval q{
        package MyClass::Moo;
        use Moo;

        has 'attribute1' => (is => 'ro');
        has 'attribute2' => (is => 'ro');
        has 'attribute3' => (is => 'ro');
    } if ($ENV{MOO});

    eval q{
    use experimental 'class';

    class MyClass::CoreClass {
        field $attribute1 :param;
        field $attribute2 :param;
        field $attribute3 :param;

        method attribute1() { $attribute1 }
        method attribute2() { $attribute2 }
        method attribute3() { $attribute3 }
    }
    } if ($ENV{COR});

    eval q{
        package MyClass::Bless;

        sub new {
        my $class = shift;
        return bless {@_}, $class
        }

        sub attribute1 { return shift->{attribute1} }
        sub attribute2 { return shift->{attribute2} }
        sub attribute3 { return shift->{attribute3} }
    } if $ENV{BLESS};
}
# Create and then access attributes

sub test_case1 {
  my $obj = MyClass::Moose->new(
    attribute1 => 'hello',
    attribute2 => 42,
    attribute3 => 1);
  my $attribute1 = $obj->attribute1;
  my $attribute2 = $obj->attribute2;
  my $attribute3 = $obj->attribute3;
}

sub test_case2 {
  my $obj = MyClass::Moo->new(
    attribute1 => 'hello',
    attribute2 => 42,
    attribute3 => 1);
  my $attribute1 = $obj->attribute1;
  my $attribute2 = $obj->attribute2;
  my $attribute3 = $obj->attribute3;
}

sub test_case3 {
  my $obj = MyClass::CoreClass->new(
    attribute1 => 'hello',
    attribute2 => 42,
    attribute3 => 1);
  my $attribute1 = $obj->attribute1;
  my $attribute2 = $obj->attribute2;
  my $attribute3 = $obj->attribute3;
}

sub test_case_bless1 {
  my $obj = MyClass::Bless->new(
    attribute1 => 'hello',
    attribute2 => 42,
    attribute3 => 1);
  my $attribute1 = $obj->attribute1;
  my $attribute2 = $obj->attribute2;
  my $attribute3 = $obj->attribute3;
}

# Just Create object

sub test_case4 {
  my $obj = MyClass::Moose->new(
    attribute1 => 'hello',
    attribute2 => 42,
    attribute3 => 1);
}

sub test_case5 {
  my $obj = MyClass::Moo->new(
    attribute1 => 'hello',
    attribute2 => 42,
    attribute3 => 1);
}

sub test_case6 {
  my $obj = MyClass::CoreClass->new(
    attribute1 => 'hello',
    attribute2 => 42,
    attribute3 => 1);
}

sub test_case_bless2 {
  my $obj = MyClass::Bless->new(
    attribute1 => 'hello',
    attribute2 => 42,
    attribute3 => 1);
}

use Benchmark qw(:all);
timethis(20000000, \&test_case1, "Moose: Create and access") if $ENV{MOOSE};
timethis(20000000, \&test_case2, "Moo: Create and access") if $ENV{MOO};
timethis(20000000, \&test_case3, "Core: Create and access") if $ENV{COR};
timethis(20000000, \&test_case_bless1, "Bless: Create and access") if $ENV{BLESS};
timethis(20000000, \&test_case4, "Moose: Create object") if $ENV{MOOSE};
timethis(20000000, \&test_case5, "Moo: Create object") if $ENV{MOO};
timethis(20000000, \&test_case6, "Core: Create object") if $ENV{COR};
timethis(20000000, \&test_case_bless2, "Bless: Create object") if $ENV{BLESS};

use Devel::Size 'total_size';

eval q{
  my $obj = MyClass::Moose->new(
    attribute1 => 'hello',
    attribute2 => 42,
    attribute3 => 1);

  my $size = total_size($obj);
  print "Moose size: $size bytes\n";
} if $ENV{MOOSE};

eval q{
  my $obj = MyClass::Moo->new(
    attribute1 => 'hello',
    attribute2 => 42,
    attribute3 => 1);

  my $size = total_size($obj);
  print "Moo size: $size bytes\n";
} if ($ENV{MOO});

eval q{
  my $obj = MyClass::CoreClass->new(
    attribute1 => 'hello',
    attribute2 => 42,
    attribute3 => 1);

  my $size = total_size($obj);
  print "Core size: $size bytes\n";
} if ($ENV{COR});

eval q{
  my $obj = MyClass::Bless->new(
    attribute1 => 'hello',
    attribute2 => 42,
    attribute3 => 1);

  my $size = total_size($obj);
  print "Bless size: $size bytes\n";
} if $ENV{BLESS};

__END__
