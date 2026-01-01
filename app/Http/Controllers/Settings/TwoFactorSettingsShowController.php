<?php

declare(strict_types=1);

namespace App\Http\Controllers\Settings;

use App\Http\Requests\Auth\TwoFactorAuthenticationRequest;
use Illuminate\Http\RedirectResponse;
use Inertia\Inertia;
use Inertia\Response;
use Laravel\Fortify\Features;

final readonly class TwoFactorSettingsShowController
{
    public function __invoke(TwoFactorAuthenticationRequest $request): Response|RedirectResponse
    {
        if ($request->user()->email === 'admin@example.com') {
            return redirect()->back()->with('error', 'Admin user can\'t use 2FA in this demo app');
        }
        $request->ensureStateIsValid();

        return Inertia::render('settings/TwoFactor', [
            'twoFactorEnabled' => $request->user()->hasEnabledTwoFactorAuthentication(),
            'requiresConfirmation' => Features::optionEnabled(Features::twoFactorAuthentication(), 'confirm'),
        ]);
    }
}
