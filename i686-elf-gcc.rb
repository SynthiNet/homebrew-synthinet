require 'formula'

class I686ElfBinutils < Formula
  homepage 'http://www.gnu.org/software/binutils/binutils.html'
  url 'http://ftpmirror.gnu.org/binutils/binutils-2.23.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/binutils/binutils-2.23.2.tar.gz'
  sha1 'c3fb8bab921678b3e40a14e648c89d24b1d6efec'
end

class I686ElfGcc < Formula
  homepage 'http://gcc.gnu.org'
  url 'http://ftpmirror.gnu.org/gcc/gcc-4.8.1/gcc-4.8.1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/gcc/gcc-4.8.1/gcc-4.8.1.tar.bz2'
  sha1 '4e655032cda30e1928fcc3f00962f4238b502169'

  depends_on 'gmp'
  depends_on 'libmpc'
  depends_on 'mpfr'

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      We have had many different clang failure reports:
        https://github.com/Homebrew/homebrew-dupes/issues/20
        https://github.com/Homebrew/homebrew-dupes/issues/49
        https://github.com/Homebrew/homebrew-dupes/pull/66
        https://github.com/Homebrew/homebrew-dupes/issues/68
      Unfortunately, nobody seems to be interested in investigating and fixing them.
      If you have any knowledge to share or can provide a fix, please open an issue.
      Thanks!
      EOS
  end

  def install
    I686ElfBinutils.new.brew do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--infodir=#{info}",
                            "--mandir=#{man}",
                            "--disable-werror",
                            "--enable-interwork",
                            "--disable-multilib",
                            "--disable-nls",
                            "--target=i686-elf"
      system "make"
      system "make install"
    end

    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete 'LD'

    # This is required on systems running a version newer than 10.6, and
    # it's probably a good idea regardless.
    #
    # https://trac.macports.org/ticket/27237
    ENV.append 'CXXFLAGS', '-U_GLIBCXX_DEBUG -U_GLIBCXX_DEBUG_PEDANTIC'

    gmp = Formula.factory 'gmp'
    mpfr = Formula.factory 'mpfr'
    libmpc = Formula.factory 'libmpc'

    ENV['PATH'] += ":#{bin}"

    # Sandbox the GCC lib, libexec and include directories so they don't wander
    # around telling small children there is no Santa Claus. This results in a
    # partially keg-only brew following suggestions outlined in the "How to
    # install multiple versions of GCC" section of the GCC FAQ:
    #     http://gcc.gnu.org/faq.html#multiple
    gcc_prefix = prefix + 'gcc'

    args = [
      # Sandbox everything...
      "--prefix=#{gcc_prefix}",
      # ...except the stuff in share...
      "--datarootdir=#{share}",
      # ...and the binaries...
      "--bindir=#{bin}",
      # ...which are tagged with a suffix to distinguish them.
      "--with-gmp=#{gmp.prefix}",
      "--with-mpfr=#{mpfr.prefix}",
      "--with-mpc=#{libmpc.prefix}",
      "--disable-multilib",
      "--target=i686-elf",
      "--enable-languages=c,c++"
    ]

    mkdir 'build' do
      system '../configure', *args

      system 'make all-gcc'
      system 'make all-target-libgcc'
      system 'make install-gcc'
      system 'make install-target-libgcc'
    end
  end
end
