#! /usr/bin/env fawk

! FLAG &&
/^ResolverName/ {
  sub("^","#",$1);
  FLAG=1
}

{ print }

