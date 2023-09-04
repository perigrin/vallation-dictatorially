{
  package MyClass::Moose;
  use Moose;

  has 'attribute1' => (is => 'ro');
  has 'attribute2' => (is => 'ro');
  has 'attribute3' => (is => 'ro');

  MyClass::Moose->meta->make_immutable;
}

{
    package MyClass::Moo;
    use Moo;

    has 'attribute1' => (is => 'ro');
    has 'attribute2' => (is => 'ro');
    has 'attribute3' => (is => 'ro');
}

{
  use feature 'class';

  class MyClass::CoreClass {
    field $attribute1 :param;
    field $attribute2 :param;
    field $attribute3 :param;

    method attribute1() { $attribute1 }
    method attribute2() { $attribute2 }
    method attribute3() { $attribute3 }
  }
}

{
    package MyClass::Bless;

    sub new {
      my $class = shift;
      return bless \%args, $class
    }

    sub attribute1 { return shift->{attribute1} }
    sub attribute2 { return shift->{attribute2} }
    sub attribute3 { return shift->{attribute3} }
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
timethis(20000000, \&test_case1, "Moose: Create and access");
timethis(20000000, \&test_case2, "Moo: Create and access");
timethis(20000000, \&test_case3, "Core: Create and access");
timethis(20000000, \&test_case_bless1, "Bless: Create and access");
timethis(20000000, \&test_case4, "Moose: Create object");
timethis(20000000, \&test_case5, "Moo: Create object");
timethis(20000000, \&test_case6, "Core: Create object");
timethis(20000000, \&test_case_bless2, "Bless: Create object");

use Devel::Size 'total_size';

{
  my $obj = MyClass::Moose->new(
    attribute1 => 'hello',
    attribute2 => 42,
    attribute3 => 1);

  my $size = total_size($obj);
  print "Moose size: $size bytes\n";
}

{
  my $obj = MyClass::Moo->new(
    attribute1 => 'hello',
    attribute2 => 42,
    attribute3 => 1);

  my $size = total_size($obj);
  print "Moo size: $size bytes\n";
}

{
  my $obj = MyClass::CoreClass->new(
    attribute1 => 'hello',
    attribute2 => 42,
    attribute3 => 1);

  my $size = total_size($obj);
  print "Core size: $size bytes\n";
}

{
  my $obj = MyClass::Bless->new(
    attribute1 => 'hello',
    attribute2 => 42,
    attribute3 => 1);

  my $size = total_size($obj);
  print "Bless size: $size bytes\n";
}

__END__
