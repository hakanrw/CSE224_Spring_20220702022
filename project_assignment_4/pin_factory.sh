#!/usr/bin/bash

exec 1>pin_order.cfg

echo "#BUS_SORT"

echo
echo "#N"
echo

echo "opcode\\[0\\]"
echo "opcode\\[1\\]"
echo "clk"

echo
echo "#W"
echo

for i in {0..31}; do
	echo "inputA\\[$i\\]"
done

echo
echo "#E"
echo

for i in {0..31}; do
	echo "inputB\\[$i\\]"
done

echo
echo "#S"
echo

for i in {0..31}; do
	echo "result\\[$i\\]"
done
