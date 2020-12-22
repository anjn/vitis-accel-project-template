#!/bin/sh

sed -ru "s/^ERROR.*\$$/\o033[1;31m\0\o033[0m/g" \
	| sed -ru "s/^.*Unable to pipeline.*\$$/\o033[1;31m\0\o033[0m/g" \
	| sed -ru "s/^.*Unable to schedule.*\$$/\o033[1;31m\0\o033[0m/g" \
	| sed -ru "s/^.*II Violation.*\$$/\o033[1;31m\0\o033[0m/g" \
	| sed -ru "s/^WARNING.*\$$/\o033[1;33m\0\o033[0m/g" \
	| sed -ru "s/^.*Final II.*\$$/\o033[1;34m\0\o033[0m/g" \
	| sed -ru "s/^.*Burst read of variable length and bit width.*\$$/\o033[1;34m\0\o033[0m/g" \
	| sed -ru "s/^.*Burst write of variable length and bit width.*\$$/\o033[1;34m\0\o033[0m/g" \
	| sed -ru "s/^.* Burst read of length.*\$$/\o033[1;34m\0\o033[0m/g" \
	| sed -ru "s/^.* Burst write of length.*\$$/\o033[1;34m\0\o033[0m/g" \
	| sed -ru "s/^.*Inferring multiple bus burst.*\$$/\o033[1;34m\0\o033[0m/g"

