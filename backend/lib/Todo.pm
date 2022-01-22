package Todo;

sub new {
	my ($class_name, %args) = @_;
	return bless \%args, $class_name;
}

sub get_todos {
  my ($self, $id) = @_;
  my $sql = 'SELECT * FROM todo_items';
  my @params;
  if ($id ne '') {
    $sql .= ' WHERE item_id=?';
    push @params, $id;
  } else {
    $sql .= ' ORDER BY _order';
  }

  $sql .= ';';
	my $todos = $self->{conn}->run(sub {
		$_->selectall_arrayref($sql, { Slice => {} }, @params);
	});

  return $id ne '' ? $todos->[0] : $todos;
}

sub update_todo {
  my ($self, $item) = @_;
  $self->{conn}->run(sub {
    $_->do('UPDATE todo_items SET description=?, is_done=?, tstamp_done=IF(?="y",NOW(),NULL) WHERE item_id=?;', undef, $item->{description}, $item->{is_done}, $item->{is_done}, $item->{item_id});
  });
  return $self->get_todos($item->{item_id});
}

1;
