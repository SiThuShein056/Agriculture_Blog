import 'package:googleapis_auth/auth_io.dart';

class GetServerKey {
  Future<String> getServerKeyToken() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": "blog-app-94e6c",
        "private_key_id": "82b68d2cd5f8e86c01b08f504e3f33459411f697",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDB6T/RZ2Tth6ar\neRedwwh1383sVTrBtGLGXuFb00qzBhLxD6hPqivDbUHEO/sPIiJgGlthQYe+zphM\nMdpYhjIw8a4oO5ZMPSX5leQZBHU+b4BDl5bclRiIa9OJbynjQjXukB6LTjXJmjx6\nmbF432Dftfd+v8cErmJBnw6/9cDlHPqZpShRGHy1SrvFpS4oFPSbWhO8iGTLWjpE\nsLTphjFkGrjXl0Mn5VUIx76Vclc5oJd4DuQSWwCvChmGOpH/dAuQ0+M21K7eQCks\nOK6tRzUvnhkHNnrayTWPoH60prGdN0Gq7s3O86Kg9ozJ2uQhX5yLHcYTFF09kkn0\nPBXhi0oJAgMBAAECggEAJFTGbz6XC2YKFUCX6ygakrM/CtOhMZ/RjedDBAhfi5FM\nxTuwxlRU5MW4t8KhNGGp3SWzD1LO0zI0GLqSdVmXV9JAVitr6pbeYZfy57kNGoib\nmI5zZprMwOqq9KoOSBUks7Du+BzMORybzkCznrkDloaqe2YFLNxbbn4VrmOmI4bp\njTBCxWelpim9NFdrun6XFiSGTWwibIvh8rx42rqEgxl+zrZmZn5gUolUqnIP25yr\nXScwd9Tdvvs9PNpGFwHzk+wD8io4lSTarvX4HhcWgp2CESvmi9x49fsIM2d2FhZx\ntBmhli4BvDCIvrfmejObPSOP1daFFEikn47YoYzQnQKBgQD1tqDmbxK/9uV+7y6h\nMpaX3nYAPIwbDg6ZC7yYJnNzbWiupue7yRmNSy5vU8IJ1GclmpJzRF9Gr/x1TD/6\nrQzSnedLmXWZIkopas/9Gj8ZEslTk4G14UIvh21p46xJObqQn4AqXO5itlKeLlzM\nztMHYL01qGrCGHr55abiLoTH2wKBgQDKB3Fr5lmm203r1tie+VK2yd3qo0XoXL05\nN3xDI92StfXcvGNIeOczMjZbn94UXET0JtyU2fbbVh4Ld4NmnRpXaU+gOLCmX80O\nVSDpB8eSJIt0ENJms8nY1/oT08y9Ncv2Wtu+6C2SmRiKJ0+INyxWGpP/iAfimN6A\nkUXee5m86wKBgQD1HBmlxWeO11xYI4EAjNZs6R4NXljlJECrq2mW3cSNgLbMgvLo\nANPcfwLzSzplU90RRgCRu8LPYP8Wg9nO1pHUCHCSmaMV/367kjGo6mXHPVZYaO0b\n4nmDsDUVTGixI0VYv8O6frnO/tGrudQY+rjIw1f8DuVwebszTkQLnRwXwQKBgDdy\nsYN+tk5gVFONJOkE3tnCL8ENTMuIYHrKqrU2q8JvZGpP3iPu4u2fM2IUT3xhEp+7\n5sCHzgPG7/oPtCW+qpMhGTSNOpZ/JqVvYdfzRafrlcamM0jywUxdgopckA3CLReR\nOkx8Jr3cfOq1/VMSaX28T7BLYnajpDW/KWD1pW0/AoGAWa9c5glmMC4rLekYioFS\nMpACUVoQPCf+87VDVXu4yVkE2e8S2zHSuBZkmtQPwrLH1Y8ZiTx1gw0G/PQPMr2I\nz7xhlQQxKhhcO2hCgTrTPLehSZWdBCO+Pn/40vqy/44xjmdWElXvxZ6Ss0LFP5DQ\nvx2YB3O7HkwPIF26ccIijmM=\n-----END PRIVATE KEY-----\n",
        "client_email":
            "firebase-adminsdk-k26zs@blog-app-94e6c.iam.gserviceaccount.com",
        "client_id": "113991802718088644150",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-k26zs%40blog-app-94e6c.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
      }),
      scopes,
    );
    final accessServerKey = client.credentials.accessToken.data;
    return accessServerKey;
  }
}
