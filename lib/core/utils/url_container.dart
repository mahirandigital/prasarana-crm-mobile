class UrlContainer {
  static const String domainUrl = 'https://prasarana.mdcrm.com.my/';
  static const String baseUrl = '$domainUrl/flutex_admin_api/';
  static const String downloadUrl = '$domainUrl/download/file';
  static const String uploadPath = 'uploads';
  static const String ticketAttachmentUrl =
      '$domainUrl/download/preview_image?path=$uploadPath/ticket_attachments/';

  static RegExp emailValidatorRegExp =
      RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  // Authentication
  static const String loginUrl = 'auth/login';
  static const String logoutUrl = 'auth/logout';
  static const String forgotPasswordUrl = 'auth/forgot-password';

  // Pages
  static const String overviewUrl = 'overview';
  static const String dashboardUrl = 'dashboard';
  static const String profileUrl = 'profile';
  static const String customersUrl = 'customers';
  static const String contactsUrl = 'contacts';
  static const String projectsUrl = 'projects';
  static const String invoicesUrl = 'invoices';
  static const String contractsUrl = 'contracts';
  static const String estimatesUrl = 'estimates';
  static const String proposalsUrl = 'proposals';
  static const String ticketsUrl = 'tickets';
  static const String leadsUrl = 'leads';
  static const String tasksUrl = 'tasks';
  static const String paymentsUrl = 'payments';
  static const String itemsUrl = 'items';
  static const String miscellaneousUrl = 'miscellaneous';
  static const String privacyPolicyUrl = 'policy-pages';

  // Download URLs
  static const String leadAttachmentUrl = '$downloadUrl/lead_attachment';
  static const String salesAttachmentUrl = '$downloadUrl/sales_attachment';
}
