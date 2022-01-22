use Mojolicious::Lite;

get '/' => sub {
	my $c = shift;
	return $c->render(text => 'hello world!');
};

app->start;
