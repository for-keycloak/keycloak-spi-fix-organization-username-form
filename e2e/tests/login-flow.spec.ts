import { test, expect } from '@playwright/test';

const BASE_URL = process.env.BASE_URL || 'http://keycloak-main:8080';
const REALM = 'test-realm';
const ACCOUNT_URL = `${BASE_URL}/realms/${REALM}/account`;

test.describe('Username/Password split flow with organizations enabled', () => {

  test('regular user can login without blank page', async ({ page }) => {
    await page.goto(ACCOUNT_URL);

    // Should be on username form
    await expect(page.locator('#username')).toBeVisible();
    await page.fill('#username', 'regular-user');
    await page.click('[type="submit"]');

    // KEY ASSERTION: Should go directly to password form
    // Not a blank page with only "Sign in" button
    await expect(page.locator('#password')).toBeVisible({ timeout: 10000 });
    await expect(page.locator('#username')).not.toBeVisible();

    // Enter password and submit
    await page.fill('#password', 'password123');
    await page.click('[type="submit"]');

    // Should be logged in - redirected to account page
    await expect(page).toHaveURL(/\/account/, { timeout: 10000 });
  });

  test('IDP-linked user can login without blank page', async ({ page }) => {
    await page.goto(ACCOUNT_URL);

    // Should be on username form
    await expect(page.locator('#username')).toBeVisible();
    await page.fill('#username', 'idp-linked-user');
    await page.click('[type="submit"]');

    // KEY ASSERTION: Should see password field directly
    // This is the bug fix - without SPI, user would see blank page
    await expect(page.locator('#password')).toBeVisible({ timeout: 10000 });
    await expect(page.locator('#username')).not.toBeVisible();

    // Enter password and submit
    await page.fill('#password', 'password123');
    await page.click('[type="submit"]');

    // Should be logged in
    await expect(page).toHaveURL(/\/account/, { timeout: 10000 });
  });

});
