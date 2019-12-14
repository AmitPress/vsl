// Copyright (c) 2019 Ulises Jeremias Cornejo Fandos. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.

module roots

import math
import vsl

/**
 * Find the root of a function using Newton's algorithm with the Armijo line
 * search to ensure the absolute value of the function decreases along the
 * iterations.  The descent direction at step k is given by
 *
 *     d_k = f(x_k) / f'(x_k)
 *
 * Determine alpha_k = max{2^{-j}, j ge 0} f s.t.
 *
 *   f(x_k + alpha_k d_k) le f(x_k) (1 - omega alpha_k)
 *
 * where in this implementation f omega = 10^{-4} f.
 *
 * @param Function
 * @param x0 initial guess
 * @param x_eps if the relative improvement over the root is less than this value,
 * then stop;
 * @param fx_eps if |f(x)| < fx_eps * then stop;
 * @param n_max maximum number of iterations
 *
 */
pub fn roots_newton(func vsl.FunctionFdf, x0, x_eps, fx_eps f64, n_max u64) ?f64 {
        omega := 1e-4
        gamma := 0.5
        mut root := x0

        mut f, mut df := func.eval_f_df(root)

        mut i := u64(0)
        for i < n_max {
                mut t := f64(1.0)

                if df == 0.0 {
                        panic('div by zero')
                }

                dx := f / df
                norm0 := math.abs(f)
                mut norm := f64(0.0)

                /* Armijo line search */
                for !t.eq(0.0) {
                        x_linesearch := root - t * dx

                        f, df = func.eval_f_df(x_linesearch)
                        norm = math.abs(f)

                        if norm < norm0 * (1.0 - omega * t) {
                                root = x_linesearch
                                break
                        }

                        t *= gamma
                }

                if math.abs(dx) < x_eps * math.abs(root) || norm < fx_eps {
                        break
                }

                i++
        }

        /* maximum number of iterations reached */
        if i == n_max {
                return error('maximum number of iterations reached')
        }

        return root
}
