Attempted to check out a raytracing nim program that uses 'sdl.' Discovered that the official package manager will not
install with the default package provided by debian.

Went through the trouble of installing latest devel versions from git repos to see that the sdl package used by the
package manager is no longer available, and sdl2 is available but not what the raytracer uses. Gave up.

The "nim check" command falls into an infinite loop given the following: 'proc `,`() = discard'. vim will freeze if you
try to SyntasticCheck a file with this. Filed bug report, not reproducible on maintainer's OSX machine.

