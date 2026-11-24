/** Identidade da instalação; configure PUBLIC_TEACHER_NAME na hospedagem. */
import { version as systemVersion } from '../../package.json';

export const teacherName = import.meta.env.PUBLIC_TEACHER_NAME?.trim() || 'Professor Deivid Nobre';
export const siteTitle = `${teacherName} - Apostilas`;
export { systemVersion };
