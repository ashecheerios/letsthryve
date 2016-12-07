class GetStartedReceiver < AbstractReceiver

  # Catches when the user presses the get started button
  def get_started
    intro_and_request_permissions
  end

  def intro_and_request_permissions
    multi_message do
      MessageSender.new(@user).set_message(:introduction_part_1).deliver!
      PromptSender
        .new(@user)
        .set_message(:introduction_part_2)
        .add_url_button(title: 'Ok',
                        url: with_fb_login('/login_success', {m_id: @user.fb_messenger_id}),
                        webview_size: 'tall',
                        use_extensions: true)
        .deliver!
    end
  end

  def initial_preferences
    multi_message do
      MessageSender
        .new(@user)
        .set_message(:fb_setup_complete, name: @user.first_name, friends_count: @user.friends.count)
        .deliver!

      PromptSender
        .new(@user)
        .set_message(:see_whats_happening)
        .add_url_button(title: 'What\'s Happening',
                        url: with_fb_login('/newsfeed', {m_id: @user.fb_messenger_id}),
                        webview_size: 'full',
                        use_extensions: true)
        .add_url_button(title: 'New Invite',
                        url: with_fb_login('/invites/new', {m_id: @user.fb_messenger_id}),
                        webview_size: 'full',
                        use_extensions: true)
        .deliver!
    end
  end

  def send_invite_card(invite)
    multi_message do
      sender = CardSender.new(@user)
      sender.add_card(title: "Invitation: #{invite.what}. #{invite.when} - #{invite.where}",
                      subtitle: "#{invite.details}. Click on the image above to respond.",
                      image_url: 'thryve.png')
            .add_url_button(url: with_fb_login('/invites/respond', {invite_id: invite.id}),
                            webview_size: 'tall', as_default_action: true)
            .add_share_button
      Rails.logger.error("\n\n============================================\n")
      Rails.logger.error(@user.id)
      Rails.logger.error("mid: #{@user.fb_messenger_id}")
      Rails.logger.error("Invitation: #{invite.what}. #{invite.when} - #{invite.where}")
      Rails.logger.error("#{invite.details}. Click on the image above to respond.")
      Rails.logger.error(with_fb_login('/invites/respond', {invite_id: invite.id}))
      Rails.logger.error("\n\nEND========================================\n")
      sender.deliver!

    end
  end

end