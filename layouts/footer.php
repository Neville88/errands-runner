        </div>
    </main>
    <footer class="border-t border-[#E5E7EB]/60 bg-[#1F2933]/88 backdrop-blur">
        <div class="mx-auto flex max-w-7xl flex-col gap-3 px-4 py-6 text-sm text-[#F7F7F2]/80 sm:px-6 lg:flex-row lg:items-center lg:justify-between lg:px-8">
            <p>&copy; <?= date('Y') ?> <?= h(APP_NAME) ?>. Structured errands, quotations, assignments, and operations oversight.</p>
            <div class="space-y-1 text-[#F7F7F2]/80 lg:text-right">
                <p>
                    Support email:
                    <a href="mailto:<?= h(APP_SUPPORT_EMAIL) ?>" class="font-medium text-[#22C55E]">
                        <?= h(APP_SUPPORT_EMAIL) ?>
                    </a>
                </p>
                <p>
                    Support phone:
                    <a href="https://wa.me/256706888958" class="font-medium text-[#22C55E]">
                        Chat on WhatsApp (+256 706 888958)
                    </a>
                    <span class="mx-1 text-[#E5E7EB]/60">|</span>
                    <a href="tel:+256706888958" class="font-medium text-[#22C55E]">
                        Call +256 706 888958
                    </a>
                </p>
            </div>
        </div>
    </footer>
</div>
</body>
</html>