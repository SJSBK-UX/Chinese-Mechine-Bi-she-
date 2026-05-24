const trimTrailingSlash = (value: string) => value.replace(/\/+$/, '');

export const API_DOMAIN = trimTrailingSlash(import.meta.env.VITE_API_DOMAIN || 'http://47.118.23.173');
export const SPRING_API = trimTrailingSlash(import.meta.env.VITE_SPRING_API || `${API_DOMAIN}/api`);
export const FLASK_API = trimTrailingSlash(import.meta.env.VITE_FLASK_API || `${API_DOMAIN}/flask`);
export const SOCKET_URL = trimTrailingSlash(import.meta.env.VITE_SOCKET_URL || API_DOMAIN);

export const UPLOAD_URL = `${SPRING_API}/files/upload`;
export const FOLDER_UPLOAD_URL = `${SPRING_API}/files/uploadFolder`;
