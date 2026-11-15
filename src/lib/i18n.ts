import { getLocales } from "expo-localization";
import { createInstance } from "i18next";
import { initReactI18next } from "react-i18next";

import en from "./locales/en.json";
import id from "./locales/id.json";
import { type AppLanguage, getLanguage, setLanguage } from "./storage/prefs";

const deviceLanguage = getLocales()[0]?.languageCode ?? "id";
const initialLanguage = getLanguage(deviceLanguage === "en" ? "en" : "id");
const i18next = createInstance();

void i18next.use(initReactI18next).init({
  resources: { en: { translation: en }, id: { translation: id } },
  lng: initialLanguage,
  fallbackLng: "id",
  interpolation: { escapeValue: false },
});

export const changeAppLanguage = (language: AppLanguage): void => {
  setLanguage(language);
  void i18next.changeLanguage(language);
};

export { i18next };
