import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

// This function can be marked `async` if using `await` inside
export function middleware(request: NextRequest) {
  const token = request.cookies.get('token')?.value;
  console.log('token', token);
  const { pathname } = request.nextUrl;

  // Define protected routes
  const isProtectedRoute = 
  pathname.startsWith('/dashboard') || 
                          pathname.startsWith('/loans') || 
                          pathname.startsWith('/users') ||
                          pathname.startsWith('/staff') ||
                          pathname.startsWith('/reports') ||
                          pathname.startsWith('/journal') ||
                          pathname.startsWith('/sms') ||
                          pathname.startsWith('/interest') ||
                          pathname.startsWith('/calculator');

  // Define auth routes
  const isAuthRoute = pathname.startsWith('/login');

  // Redirect to login if accessing protected route without token
  if (isProtectedRoute && !token) {
    const url = new URL('/login', request.url);
    url.searchParams.set('callbackUrl', encodeURI(pathname));
    return NextResponse.redirect(url);
  }

  // Redirect to dashboard if accessing auth route with token
  if (isAuthRoute && token) {
    return NextResponse.redirect(new URL('/dashboard', request.url));
  }

  return NextResponse.next();
}

// See "Matching Paths" below to learn more
export const config = {
  matcher: [
    /*
     * Match all request paths except for the ones starting with:
     * - api (API routes)
     * - _next/static (static files)
     * - _next/image (image optimization files)
     * - favicon.ico (favicon file)
     * - public folder
     */
    '/((?!api|_next/static|_next/image|favicon.ico|.*\\.png$).*)',
  ],
};