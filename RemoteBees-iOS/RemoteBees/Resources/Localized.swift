// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum Action {
    /// Forgot Password?
    internal static let forgotPassword = L10n.tr("Localizable", "action.forgotPassword")
    /// Login
    internal static let login = L10n.tr("Localizable", "action.login")
    /// Search
    internal static let search = L10n.tr("Localizable", "action.search")
    /// Sign Up
    internal static let signUp = L10n.tr("Localizable", "action.signUp")
    /// Skip
    internal static let skip = L10n.tr("Localizable", "action.skip")
    /// Submit
    internal static let submit = L10n.tr("Localizable", "action.submit")
  }

  internal enum Placeholder {
    /// Email
    internal static let email = L10n.tr("Localizable", "placeholder.email")
    /// Fist Name
    internal static let firstName = L10n.tr("Localizable", "placeholder.firstName")
    /// Last Name
    internal static let lastName = L10n.tr("Localizable", "placeholder.lastName")
    /// Password
    internal static let password = L10n.tr("Localizable", "placeholder.password")
    /// Job title, keywords, or company
    internal static let search = L10n.tr("Localizable", "placeholder.search")
  }

  internal enum Title {
    /// Remote Bees
    internal static let brandName = L10n.tr("Localizable", "title.brandName")
    /// Find Your Happiness
    internal static let brandSlogan = L10n.tr("Localizable", "title.brandSlogan")
    /// Login
    internal static let login = L10n.tr("Localizable", "title.login")
    /// Password Reset
    internal static let passwordReset = L10n.tr("Localizable", "title.passwordReset")
    /// Sign Up
    internal static let signUp = L10n.tr("Localizable", "title.signUp")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle = Bundle(for: BundleToken.self)
}
// swiftlint:enable convenience_type
