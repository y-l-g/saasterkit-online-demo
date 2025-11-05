<?php

namespace App\Notifications;

use App\Models\TeamOwnershipInvitation;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;
use Illuminate\Support\Facades\Lang;
use Illuminate\Support\Facades\URL;

class TeamOwnershipTransferNotification extends Notification implements ShouldQueue
{
    use Queueable;

    /**
     * Create a new notification instance.
     */
    public function __construct(
        public readonly TeamOwnershipInvitation $transfer
    ) {}

    /**
     * Get the notification's delivery channels.
     *
     * @return array<int, string>
     */
    public function via(object $notifiable): array
    {
        return ['mail'];
    }

    /**
     * Get the mail representation of the notification.
     */
    public function toMail(object $notifiable): MailMessage
    {
        $acceptUrl = URL::temporarySignedRoute(
            'teams.ownership.invitations.mail.accept',
            now()->addDays(7),
            ['token' => $this->transfer->token]
        );
        $teamName = $this->transfer->team->name;
        $currentOwnerName = $this->transfer->team->owner->name;

        return (new MailMessage)
            ->subject(Lang::get('Team Ownership Transfer Invitation'))
            ->line(Lang::get('You have been invited to become the new owner of the **:team** team by **:owner**.', ['team' => $teamName, 'owner' => $currentOwnerName]))
            ->line(Lang::get('If you accept this, you will become the sole owner of the team, and :owner will be assigned a new role within the team.', ['owner' => $currentOwnerName]))
            ->line(Lang::get('This invitation will expire in 7 days.'))
            ->action(Lang::get('Accept Transfer'), $acceptUrl)
            ->line(Lang::get('If you did not expect to receive this invitation, you may discard this email.'));
    }

    /**
     * Get the array representation of the notification.
     *
     * @return array<string, mixed>
     */
    public function toArray(object $notifiable): array
    {
        return [
            //
        ];
    }
}
