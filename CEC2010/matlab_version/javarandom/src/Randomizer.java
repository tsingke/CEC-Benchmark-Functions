/*
 * Copyright (c) 2009 Thomas Weise
 * http://www.it-weise.de/
 * tweise@gmx.de
 *
 * GNU LESSER GENERAL PUBLIC LICENSE (Version 2.1, February 1999)
 */

import java.util.Random;

/**
 * A standardized implementation of the randomization of shift vectors and
 * matrices used for the experiments. The implementation of the basic
 * random methods is the same as in Java 1.6. By overriding these methods
 * here, we basically ensure that the behavior of the randmizer is the same
 * for all past and future versions of Java.
 *
 * @author Thomas Weise
 */
public class Randomizer extends Random {
  /** use serialVersionUID y */
  static final long serialVersionUID = 1;

  /** M */
  private static final long M = 0x5DEECE66DL;

  /** a */
  private static final long A = 0xBL;

  /** mask */
  private static final long MASK = (1L << 48) - 1;

  /** The randomization seed */
  private long m_seed;

  /** the internal variable holding the next gaussian number */
  private double m_nextNextGaussian;

  /**
   * the internal variable indicating whether there is a next gaussian
   * number stored
   */
  private boolean m_haveNextNextGaussian = false;

  /**
   * Creates a new random number generator.
   */
  public Randomizer() {
    this(0);
  }

  /**
   * Creates a new random number generator using a single {@code long}
   * seed.
   *
   * @param seed
   *          the initial seed
   */
  public Randomizer(final long seed) {
    super(seed);
    this.m_seed = seed;
  }

  /**
   * Sets the seed of this random number generator using a single {@code
   * long} seed.
   *
   * @param seed
   *          the new seed
   */
  //@Override
  public final void setSeed(long seed) {
    this.m_seed = seed;
    super.setSeed(seed);
  }

  /**
   * Generates the next pseudorandom number.
   *
   * @param bits
   *          random bits
   * @return the random bits
   */
  //@Override
  protected final int next(final int bits) {
    final long s;

    this.m_seed = s = (((this.m_seed * M) + A) & MASK);
    return (int) (s >>> (48 - bits));
  }

  /**
   * Returns a pseudorandom, uniformly distributed {@code int} value
   * between 0 (inclusive) and the specified value (exclusive), drawn from
   * this random number generator's sequence.
   *
   * @param n
   *          the bound on the random number to be returned. Must be
   *          positive.
   * @return the next pseudorandom, uniformly distributed {@code int} value
   *         between {@code 0} (inclusive) and {@code n} (exclusive) from
   *         this random number generator's sequence
   */
  //@Override
  public final int nextInt(final int n) {
    int bits, val;

    if ((n & (-n)) == n) {// i.e., n is a power of 2
      return (int) ((n * (long) next(31)) >> 31);
    }

    do {
      bits = next(31);
      val = bits % n;
    } while (bits - val + (n - 1) < 0);

    return val;
  }

  /**
   * Returns the next pseudorandom, uniformly distributed {@code double}
   * value between {@code 0.0} and {@code 1.0} from this random number
   * generator's sequence.
   *
   * @return the next pseudorandom, uniformly distributed {@code double}
   *         value between {@code 0.0} and {@code 1.0} from this random
   *         number generator's sequence
   * @see Math#random
   */
  //@Override
  public final double nextDouble() {
    return ((((long) (next(26)) << 27) + next(27)) / (double) (1L << 53));
  }

  /**
   * Returns the next pseudorandom, Gaussian ("normally") distributed
   * {@code double} value with mean {@code 0.0} and standard deviation
   * {@code 1.0} from this random number generator's sequence.
   *
   * @return the next pseudorandom, Gaussian ("normally") distributed
   *         {@code double} value with mean {@code 0.0} and standard
   *         deviation {@code 1.0} from this random number generator's
   *         sequence
   */
  //@Override
  public final double nextGaussian() {
    double multiplier, v1, v2, s;

    if (this.m_haveNextNextGaussian) {
      this.m_haveNextNextGaussian = false;
      return this.m_nextNextGaussian;
    }

    do {
      v1 = ((2d * this.nextDouble()) - 1d);
      v2 = ((2d * this.nextDouble()) - 1d);
      s = ((v1 * v1) + (v2 * v2));
    } while ((s >= 1d) || (s == 0d));
    multiplier = StrictMath.sqrt(-2.d * StrictMath.log(s) / s);

    this.m_nextNextGaussian = (v2 * multiplier);
    this.m_haveNextNextGaussian = true;

    return (v1 * multiplier);
  }

  /**
   * Create a new shifting vector
   *
   * @param dim
   *          the dimension of the vector
   * @param min
   *          the minimum value a decision variable can take on
   * @param max
   *          the maximum value a decision variable can take on
   * @return the shift vector
   */
  public final double[] createShiftVector(final int dim, final double min,
      final double max) {
    final double[] d;
    final double hw, middle;
    double s;
    int i;

    hw = (0.5d * (max - min));
    middle = (min + hw);
    d = new double[dim];

    for (i = (dim - 1); i >= 0; i--) {
      do {
        s = (middle + (this.nextGaussian() * hw));
      } while ((s < min) || (s > max));
      d[i] = s;
    }

    return d;
  }

  /**
   * Create a random permutation vector of the numbers 0 to dim-1
   *
   * @param dim
   *          the number of dimensions
   * @return the permutation vector
   */
  public final int[] createPermVector(final int dim) {
    final int[] d;
    int i, j, k, t;

    d = new int[dim];

    for (i = (dim - 1); i >= 0; i--) {
      d[i] = i;
    }

    for (i = (dim << 3); i >= 0; i--) {
      j = this.nextInt(dim);
      do {
        k = this.nextInt(dim);
      } while (k == j);

      t = d[j];
      d[j] = d[k];
      d[k] = t;
    }

    return d;
  }

  /**
   * Create a random rotation matrix
   *
   * @param dim
   *          the number of dimensions
   * @return the rotation matrix
   */
  public final double[][] createRotMatrix(final int dim) {
    final double[][] m;
    int i, j, k;
    double dp, t;

    m = new double[dim][dim];

    outer: for (;;) {

      // initialize
      for (i = (dim - 1); i >= 0; i--) {
        for (j = (dim - 1); j >= 0; j--) {
          m[i][j] = this.nextGaussian();
        }
      }

      // main loop of gram/schmidt
      for (i = (dim - 1); i >= 0; i--) {

        //
        for (j = (dim - 1); j > i; j--) {

          // dot product
          dp = 0d;
          for (k = (dim - 1); k >= 0; k--) {
            dp += (m[i][k] * m[j][k]);
          }

          // subtract
          for (k = (dim - 1); k >= 0; k--) {
            m[i][k] -= (dp * m[j][k]);
          }
        }

        // normalize
        dp = 0d;
        for (k = (dim - 1); k >= 0; k--) {
          t = m[i][k];
          dp += (t * t);
        }

        // linear dependency -> restart
        if (dp <= 0d) {
          continue outer;
        }
        dp = (1d / Math.sqrt(dp));

        for (k = (dim - 1); k >= 0; k--) {
          m[i][k] *= dp;
        }
      }

      return m;
    }
  }

  /**
   * Create a random rotation matrix
   *
   * @param dim
   *          the number of dimensions
   * @return the rotation matrix
   */
  public final double[] createRotMatrix1D(final int dim) {
    final double[][] a;
    final double[] b;
    int i, j, k;

    a = this.createRotMatrix(dim);
    b = new double[dim * dim];

    k = 0;
    for (i = 0; i < dim; i++) {
      for (j = 0; j < dim; j++) {
        b[k++] = a[i][j];
      }
    }

    return b;
  }

  /**
   * The test function used to check whether the routines here have been
   * implemented correctly.
   *
   * @param params
   *          the parameters
   */
  public static final void main(final String[] params) {
    double[][] m;
    double[] o;
    int[] p;
    int i, j;
    final int D = 10;
    final Randomizer r;
    final int seed = 1;

    r = new Randomizer();
    r.setSeed(seed);

    r.setSeed(seed);
    o = r.createShiftVector(D, -100d, 100d);
    for (j = 0; j < D; j++) {
      if (j > 0) {
        System.out.print(' ');
      }
      System.out.print(o[j]);
    }

    System.out.println();
    System.out.println();
    System.out.println();

    p = r.createPermVector(D);
    for (j = 0; j < D; j++) {
      if (j > 0) {
        System.out.print(' ');
      }
      System.out.print(p[j] + 1);
    }

    System.out.println();
    System.out.println();

    m = r.createRotMatrix(D);
    for (i = 0; i < D; i++) {
      for (j = 0; j < D; j++) {
        if (j > 0) {
          System.out.print(' ');
        }
        System.out.print(m[i][j]);
      }
      System.out.println();
    }

  }
}
