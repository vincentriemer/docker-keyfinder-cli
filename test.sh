#!/bin/bash

assert_equal ()
{
  E_PARAM_ERR=98
  E_ASSERT_FAILED=99

  if [ -z "$3" ]          #  Not enough parameters passed
  then                    #+ to assert() function.
    return $E_PARAM_ERR   #  No damage done.
  fi

  actual=$1
  expected=$2
  lineno=$3

  if [ "$actual" == "$expected" ]; then
    return 0
  else
    echo "Assertion failed:  \"EXPECTED: '$1'  ACTUAL: '$2'\""
    echo "File \"$0\", line $lineno"    # Give name of file and line number.
    exit $E_ASSERT_FAILED
  fi
}

expected="Cm"

echo "Executing basic test..."

raw_result="$(docker run --rm -it -v `pwd`/test-files/Cm.mp3:/test.mp3 $1 test.mp3)"
actual="$(echo -e "${raw_result}" | tr -d '[[:space:]]')"

assert_equal $actual $expected $LINENO

echo ""
echo "Succeeded!"