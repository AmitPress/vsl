// Copyright (c) 2019 Ulises Jeremias Cornejo Fandos. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.

module specfunc

import math

fn log_factorial_asymptotic_expansion(n int) f64 {
        m := 6
        mut term := [0.0].repeat(6)
        xx := f64((n + 1) * (n + 1))
        mut xj := f64(n + 1)
        
        log_factorial := log_sqrt_2pi - xj + (xj - 0.5) * math.log(xj)
        
        mut i := 0

        for i = 0; i < m; i++ {
                term[i] = B[i] / xj
                xj *= xx
        }

        mut sum := term[m-1]

        for i = m - 2; i >= 0; i-- {
                if math.abs(sum) <= math.abs(term[i]) {
                        break
                }

                sum = term[i]
        }

        for i >= 0 {
                sum += term[i]
                i--
        }

        return log_factorial + sum
}

// log_factorial calculates the log-factorial of the provided value.
pub fn log_factorial(n f64) f64 {
	// For a large postive argument (n < 0) return max_f64

	if n < 0 {
                return -math.max_f64
	}

	// If n < N then return ln(n!).

	if n != f64(i64(n)) {
		return math.log_gamma(n+1)
	} else if n < log_factorials.len {
                return log_factorials[i64(n)]
        }

	// Otherwise return asymptotic expansion of ln(n!).

        return log_factorial_asymptotic_expansion(int(n))
}
