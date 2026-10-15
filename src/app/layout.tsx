import type { Metadata } from 'next';
import './globals.css';
export const metadata: Metadata = { title: 'Hamemo — Stay close', description: 'رسائلك ومحادثاتك في مكان واحد', applicationName: 'Hamemo', manifest: '/manifest.json' };
export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) { return <html lang="ar" dir="rtl"><body>{children}</body></html>; }
