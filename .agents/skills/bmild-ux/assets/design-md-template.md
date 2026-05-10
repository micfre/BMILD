---
version: alpha
name: <Design system name>
description: <Optional one-line summary of the design system>
colors:
  primary: "<Primary hex color>"
  secondary: "<Optional secondary hex color>"
  tertiary: "<Optional tertiary hex color>"
  neutral: "<Optional neutral hex color>"
typography:
  <typography-token-name>:
    fontFamily: "<Font family>"
    fontSize: <Dimension>
    fontWeight: <Number>
    lineHeight: <Dimension or number>
    letterSpacing: <Dimension>
rounded:
  <scale-level>: <Dimension>
spacing:
  <scale-level>: <Dimension or number>
components:
  <component-name>:
    <property-name>: "<Literal value or {token.reference}>"
---

# DESIGN.md

## Overview

<Describe the product's overall feel, brand personality, intended audience, and the emotional response the interface should evoke. Explain what should feel distinctive, what should remain consistent across screens, and what stylistic directions should be avoided.>

## Colors

<Describe the palette in human terms. Explain the role of each major color family, where it should be used, and where it should be avoided. If the system uses semantic color roles beyond the defaults, describe them here.>

- **Primary (<hex>):** <Role and intended usage>
- **Secondary (<hex>):** <Role and intended usage>
- **Tertiary (<hex>):** <Role and intended usage>
- **Neutral (<hex>):** <Role and intended usage>

## Typography

<Describe the typography system in prose. Explain the display/body/UI hierarchy, how dense or spacious the text system should feel, and any casing, rhythm, or emphasis rules that should guide implementation.>

## Layout

<Describe spacing rhythm, content width, alignment discipline, density, grid behavior, and responsive layout principles.>

## Elevation & Depth

<Describe how hierarchy is conveyed visually. If the system is flat, explain what replaces shadows. If it uses elevation, explain the intended shadow, border, blur, or contrast treatment.>

## Shapes

<Describe corner rounding, silhouette, edge treatment, and the general shape language of the system. Explain which elements should feel sharper, softer, more geometric, or more organic.>

## Components

<Describe global component styling guidance not fully captured by tokens. Cover the component categories relevant to the project and define important states and behavioral expectations where visual consistency matters.>

- **Buttons:** <Primary, secondary, tertiary, disabled, loading, emphasis rules>
- **Inputs:** <Labels, helper text, error treatment, focus treatment, density>
- **Lists / Cards / Navigation / Dialogs / Domain-specific components:** <Guidance as relevant>

## Global UX Patterns

<Describe global interaction conventions that are not purely visual tokens.>

- <Form validation and submission rule>
- <Modal, dialog, or drawer lifecycle rule>
- <Empty, loading, or error state convention>
- <Accessibility or responsive baseline>

## Do's and Don'ts

- **Do:** <Specific pattern to preserve>
- **Do:** <Specific pattern to preserve>
- **Don't:** <Specific misuse that would break the system>
- **Don't:** <Specific misuse that would break the system>

## Distillation Log

Append-only. Add an entry each time this document is updated. Format: date | initiative-name | what was distilled.

- [YYYY-MM-DD] | [initiative-name] | [one-line description of what was distilled]
