package ch.jacem.for_keycloak.fix_organization_username_form;

import org.keycloak.authentication.Authenticator;
import org.keycloak.authentication.authenticators.browser.UsernameFormFactory;
import org.keycloak.models.KeycloakSession;

public class CustomUsernameFormFactory extends UsernameFormFactory {
    public static final String PROVIDER_ID = "auth-username-form";

    @Override
    public Authenticator create(KeycloakSession session) {
        return new CustomUsernameForm();
    }

    @Override
    public String getHelpText() {
        return "Selects a user from his username (with organizations fix).";
    }
}
