use Mojolicious::Lite;
use DBIx::Connector;
use lib './lib';
use Todo;

hook after_dispatch => sub { 
  my $c = shift; 
  $c->res->headers->header('Access-Control-Allow-Origin' => '*'); 
  $c->res->headers->header('Access-Control-Allow-Headers' => 'Content-Type'); 
  $c->res->headers->header('Access-Control-Allow-Methods' => 'POST'); 
}; 

my $conn = DBIx::Connector->new("dbi:mysql:mysql_read_default_file=$ENV{HOME}/.database.cnf;mysql_read_default_group=foobar", undef, undef, {});

helper todo => sub {
	my $c = shift;
	return Todo->new(conn => $conn);
};

get '/todos' => sub {
	my $c = shift;
	return $c->render(json => $c->todo->get_todos);
};

post '/todos/:id' => sub {
  my $c = shift;
  return $c->render(json => $c->todo->update_todo($c->req->json));
};

options '/todos/:id' => sub {
  my $c = shift;
  $c->rendered(200);
};

app->start;
