let currentLang = 'en';
let translations = {};

async function loadTranslations(lang) {
  try {
    const response = await fetch(`locales/${lang}.json`);
    translations = await response.json();
    currentLang = lang;
    document.documentElement.lang = lang;
    applyTranslations();
  } catch (err) {
  alert("Failed to load translations", err);
}
}


function t(key) {
  return translations[key];
}

function applyTranslations() {
  document.querySelectorAll('[data-i18n]').forEach(el => {
    const key = el.getAttribute('data-i18n');
    if (key) el.textContent = t(key); 
  });

  if (shieldText) shieldText.textContent = t('shieldText');
  document.getElementById('connectBtn').textContent = t('connectWallet');
  document.querySelector('#packageSection label strong').textContent = t('chooseProtectionLevel');
}

function changeLanguage(lang) {
  loadTranslations(lang);
  localStorage.setItem('preferredLang', lang);
}

window.addEventListener('load' (0 => {
  const savedLang = localStorage.getItem('preferredLang') || 
  (navigator.languageStartsWith('cs')?'cs':
  (navigator.language.startsWith('mr')?'mr':
  'en');
  loadTranslations(savedLang);
});
