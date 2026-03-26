<?php

declare(strict_types=1);

function form_input(string $name, string $label, string $value = '', string $type = 'text', bool $required = false, string $placeholder = ''): string
{
    $requiredAttribute = $required ? 'required' : '';
    return sprintf(
        '<label class="block"><span class="mb-2 block text-sm font-medium text-[#1F2933]">%s</span><input type="%s" name="%s" value="%s" placeholder="%s" %s class="w-full rounded-2xl border border-[#E5E7EB] bg-[#F7F7F2]/95 px-4 py-3 text-sm text-[#1F2933] outline-none transition focus:border-[#22C55E] focus:ring-2 focus:ring-[#22C55E]/20"></label>',
        htmlspecialchars($label, ENT_QUOTES, 'UTF-8'),
        htmlspecialchars($type, ENT_QUOTES, 'UTF-8'),
        htmlspecialchars($name, ENT_QUOTES, 'UTF-8'),
        htmlspecialchars($value, ENT_QUOTES, 'UTF-8'),
        htmlspecialchars($placeholder, ENT_QUOTES, 'UTF-8'),
        $requiredAttribute
    );
}

function form_textarea(string $name, string $label, string $value = '', bool $required = false, string $placeholder = ''): string
{
    $requiredAttribute = $required ? 'required' : '';
    return sprintf(
        '<label class="block"><span class="mb-2 block text-sm font-medium text-[#1F2933]">%s</span><textarea name="%s" rows="5" placeholder="%s" %s class="w-full rounded-2xl border border-[#E5E7EB] bg-[#F7F7F2]/95 px-4 py-3 text-sm text-[#1F2933] outline-none transition focus:border-[#22C55E] focus:ring-2 focus:ring-[#22C55E]/20">%s</textarea></label>',
        htmlspecialchars($label, ENT_QUOTES, 'UTF-8'),
        htmlspecialchars($name, ENT_QUOTES, 'UTF-8'),
        htmlspecialchars($placeholder, ENT_QUOTES, 'UTF-8'),
        $requiredAttribute,
        htmlspecialchars($value, ENT_QUOTES, 'UTF-8')
    );
}

function form_select(string $name, string $label, array $options, string $selected = '', bool $required = false): string
{
    $requiredAttribute = $required ? 'required' : '';
    $html = sprintf('<label class="block"><span class="mb-2 block text-sm font-medium text-[#1F2933]">%s</span><select name="%s" %s class="w-full rounded-2xl border border-[#E5E7EB] bg-[#F7F7F2]/95 px-4 py-3 text-sm text-[#1F2933] outline-none transition focus:border-[#22C55E] focus:ring-2 focus:ring-[#22C55E]/20">', htmlspecialchars($label, ENT_QUOTES, 'UTF-8'), htmlspecialchars($name, ENT_QUOTES, 'UTF-8'), $requiredAttribute);
    foreach ($options as $value => $text) {
        $html .= sprintf('<option value="%s" %s>%s</option>', htmlspecialchars((string) $value, ENT_QUOTES, 'UTF-8'), $selected === (string) $value ? 'selected' : '', htmlspecialchars($text, ENT_QUOTES, 'UTF-8'));
    }
    $html .= '</select></label>';
    return $html;
}

function form_file(string $name, string $label, string $accept = 'image/*'): string
{
    return sprintf(
        '<label class="block"><span class="mb-2 block text-sm font-medium text-[#1F2933]">%s</span><input type="file" name="%s" accept="%s" class="w-full rounded-2xl border border-dashed border-[#22C55E]/40 bg-[#F7F7F2]/90 px-4 py-3 text-sm text-[#1F2933] file:mr-4 file:rounded-xl file:border-0 file:bg-[#14532D] file:px-4 file:py-2 file:text-sm file:font-semibold file:text-[#F7F7F2]"></label>',
        htmlspecialchars($label, ENT_QUOTES, 'UTF-8'),
        htmlspecialchars($name, ENT_QUOTES, 'UTF-8'),
        htmlspecialchars($accept, ENT_QUOTES, 'UTF-8')
    );
}