.PHONY: worker test

worker:
	carton exec perl -Ilib script/koyomi

test:
	carton exec prove -Ilib -rv t/
