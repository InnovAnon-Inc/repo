#! /usr/bin/env fawk

BEGIN { FS="," }

  NR > 1      &&
( $8 == "yes" ||
  $8 >= 1 ) {
  print("ResolverName "$1)
}

