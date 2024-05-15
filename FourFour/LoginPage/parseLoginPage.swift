//
//  parseLoginPage.swift
//  FourDay
//
//  Created by Charles Thomas on 2024/5/8.
//
import SwiftSoup

func parseLoginPage(html: String) throws -> (usernamePlaceholder: String?, passwordLabel: String?, securityQuestions: [(value: String, text: String)], securityAnswerStyle: String?, loginButtonText: String?, rememberMeChecked: Bool, rememberMeLabel: String) {
    let document = try SwiftSoup.parse(html)

    // 1. Username input
    let usernameInput = try document.select("input[name=username]").first()
    let usernamePlaceholder = try usernameInput?.attr("value")

    // 2. Password input and label
    let passwordInput = try document.select("input[name=password]").first()
    let passwordLabel = try document.select("label[for=password]").text()

    // 3. Security question dropdown and options
    let securityQuestion = try document.select("select[name=questionid]").first()
    let securityQuestionOptions = try securityQuestion?.select("option")
    var questions = [(value: String, text: String)]()
    if let options = securityQuestionOptions {
        for option in options {
            let value = try option.val()
            let text = try option.text()
            questions.append((value: value, text: text))
        }
    }

    // 4. Security answer input
    let answerInput = try document.select("input[name=answer]").first()
    let answerStyle = try answerInput?.attr("style")

    // 5. Login button
    let loginButton = try document.select("button[name=loginsubmit]").first()
    let loginButtonText = try loginButton?.text()

    // 6. Checkbox for "Remember me" and its label
    let rememberMeCheckbox = try document.select("input[type=checkbox][name=cookietime]").first()
    let rememberMeChecked = (try rememberMeCheckbox?.attr("checked") != nil)
    let rememberMeLabel = try document.select("label[for=cookietime]").text()

    return (usernamePlaceholder, passwordLabel, questions, answerStyle, loginButtonText, rememberMeChecked, rememberMeLabel)
}
