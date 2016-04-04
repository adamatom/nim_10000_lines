Devs expect you to use devel branch, which requires git clones that are not intuitive.

Attempted to check out a raytracing nim program that uses 'sdl.' Discovered that the official package manager will not
install with the default package provided by debian.

Went through the trouble of installing latest devel versions from git repos to see that the sdl package used by the
package manager is no longer available, and sdl2 is available but not what the raytracer uses. Gave up.

The "nim check" command falls into an infinite loop given the following: 'proc `,`() = discard'. vim will freeze if you
try to SyntasticCheck a file with this. Filed bug report, not reproducible on maintainer's OSX machine.

When first learning to use seq[T], I constantly used it uninitialized. var v: set[T] starts its life as nil. This was
a hassle at first.

Reported a bug in the tools and a day later it was fixed.

