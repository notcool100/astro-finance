/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export', // 👈 Required for static export (next export)

  eslint: {
    ignoreDuringBuilds: true,
  },
  typescript: {
    ignoreBuildErrors: true,
  },
  images: {
    unoptimized: true, // 👈 Required for static export if using <Image>
  },
}

export default nextConfig
