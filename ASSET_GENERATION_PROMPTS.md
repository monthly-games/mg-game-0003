# MG-0003 픽셀 용병단 키우기 - 에셋 생성 프롬프트

## 📊 필요한 에셋 목록

### 🎨 이미지 에셋

#### 영웅 스프라이트 (3개)
1. **hero_knight.png** (64x64px) - 탱커 기사
2. **hero_ranger.png** (64x64px) - 궁수
3. **hero_cleric.png** (64x64px) - 힐러

#### 몬스터 스프라이트 (2개)
4. **monster_basic.png** (64x64px) - 일반 몬스터
5. **monster_boss.png** (96x96px) - 보스 몬스터

#### 배경 이미지 (1개)
6. **bg_battle.png** (1920x1080px) - 전투 배경

#### UI 아이콘 (2개)
7. **icon_gold.png** (32x32px) - 골드 아이콘
8. **icon_level_up.png** (32x32px) - 레벨업 아이콘

---

### 🔊 사운드 에셋

#### 전투 효과음 (4개)
1. **sfx_hit.wav** - 공격 히트
2. **sfx_critical.wav** - 치명타
3. **sfx_heal.wav** - 힐
4. **sfx_death.wav** - 사망

#### UI 효과음 (2개)
5. **ui_click.wav** - 버튼 클릭
6. **ui_level_up.wav** - 레벨업

#### 배경음악 (1개)
7. **bgm_battle.wav** - 전투 BGM (루프, 2분)

---

## 🎨 이미지 생성 프롬프트

### 영웅 스프라이트

#### 1. hero_knight.png
```
Create a pixel art knight character sprite (64x64px).
- Style: Side view, fantasy medieval knight
- Subject: Armored knight warrior standing in battle stance
- Details: Silver/gray plate armor, blue cape, shield and sword, standing guard pose
- Color palette: Silver, gray, blue, gold accents
- Background: Transparent
- Art style: Clean pixel art, JRPG character style, readable at small size
- Pose: Standing ready for battle, facing right
```

#### 2. hero_ranger.png
```
Create a pixel art ranger character sprite (64x64px).
- Style: Side view, fantasy archer
- Subject: Agile archer with bow
- Details: Green cloak, brown leather armor, bow with quiver, alert stance
- Color palette: Green, brown, tan, silver (arrow tips)
- Background: Transparent
- Art style: Clean pixel art, JRPG character style
- Pose: Drawing bow, facing right
```

#### 3. hero_cleric.png
```
Create a pixel art cleric character sprite (64x64px).
- Style: Side view, fantasy healer
- Subject: Holy priest/cleric with staff
- Details: White robes with gold trim, holy staff, calm healing pose
- Color palette: White, gold, light blue (magical glow)
- Background: Transparent
- Art style: Clean pixel art, JRPG character style
- Pose: Standing with staff, gentle pose, facing right
```

#### 4. hero_mage.png
```
Create a pixel art mage character sprite (64x64px).
- Style: Side view, fantasy wizard
- Subject: Wizard casting a spell
- Details: Dark blue or purple robes, magical staff or orb, mystical energy
- Color palette: Purple, dark blue, cyan (magic)
- Background: Transparent
- Art style: Clean pixel art, JRPG character style
- Pose: Casting pose, holding staff forward, facing right
```

#### 5. hero_assassin.png
```
Create a pixel art assassin character sprite (64x64px).
- Style: Side view, fantasy rogue
- Subject: Stealthy assassin with daggers
- Details: Black/dark grey leather armor, dual daggers, face mask or hood
- Color palette: Black, dark grey, crimson (accents)
- Background: Transparent
- Art style: Clean pixel art, JRPG character style
- Pose: Crouched or ready to strike, holding daggers, facing right
```

### 몬스터 스프라이트

#### 4. monster_basic.png
```
Create a pixel art basic monster sprite (64x64px).
- Style: Side view, fantasy enemy
- Subject: Generic enemy creature (orc, goblin, or slime)
- Details: Menacing appearance, simple but clear design
- Color palette: Green/brown (orc) or red/purple (slime), dark tones
- Background: Transparent
- Art style: Clean pixel art, enemy unit
- Pose: Aggressive stance, facing left (opposite of heroes)
```

#### 5. monster_boss.png
```
Create a pixel art boss monster sprite (96x96px).
- Style: Side view, fantasy boss enemy
- Subject: Large intimidating boss creature (dragon, demon, or giant)
- Details: Much larger than basic monster, imposing presence, detailed armor/scales
- Color palette: Dark red, black, orange (fire), menacing colors
- Background: Transparent
- Art style: Clean pixel art, boss character, more detailed than basic monster
- Pose: Threatening pose, facing left
```

### 배경 이미지

#### 6. bg_battle.png
```
Create a fantasy battle background (1920x1080px).
- Style: Side-scrolling battlefield view
- Subject: Medieval fantasy battlefield landscape
- Details: Rocky terrain, distant mountains, some ruins, battle-worn ground, dramatic sky
- Color palette: Earthy browns, grays, ominous orange/red sky
- Art style: Game background, slightly stylized, atmospheric
- Mood: Intense, battle atmosphere, epic scale
```

### UI 아이콘

#### 7. icon_gold.png
```
Create a pixel art gold coin icon (32x32px).
- Style: Top-down view, shiny gold coin
- Subject: Single gold coin with shine
- Details: Gold metallic surface, highlight glint, embossed design
- Color palette: Gold yellow, orange highlights
- Background: Transparent
- Art style: Clean pixel art, UI quality
```

#### 8. icon_level_up.png
```
Create a pixel art level up icon (32x32px).
- Style: Symbol icon
- Subject: Upward arrow or star burst (level up indicator)
- Details: Bright, energetic, positive symbol
- Color palette: Gold/yellow, white highlights
- Background: Transparent
- Art style: Clean pixel art, UI quality, celebratory feel
```

---

## 🔊 사운드 생성 프롬프트

### 전투 효과음

**1. sfx_hit.wav**
```
Generate a combat hit sound effect.
- Duration: 0.2-0.3 seconds
- Type: Sword/weapon impact
- Tone: Solid "clang" or "thud"
- Style: Fantasy combat, satisfying impact
```

**2. sfx_critical.wav**
```
Generate a critical hit sound effect.
- Duration: 0.4-0.6 seconds
- Type: Powerful impact with magical emphasis
- Tone: Heavy "CRASH" with sparkle
- Style: Fantasy combat, critical hit emphasis, more dramatic than normal hit
```

**3. sfx_heal.wav**
```
Generate a healing sound effect.
- Duration: 0.5-0.7 seconds
- Type: Magical healing with chime
- Tone: Gentle "ding-shimmer", soothing
- Style: Fantasy magic, positive restorative sound
```

**4. sfx_death.wav**
```
Generate a death/defeat sound effect.
- Duration: 0.6-0.9 seconds
- Type: Enemy vanquishing sound
- Tone: Descending "woosh-fade" or dramatic fall
- Style: Fantasy combat, enemy defeated
```

### UI 효과음

**5. ui_click.wav**
```
Generate a short UI click sound effect.
- Duration: 0.1-0.2 seconds
- Type: Clean button click
- Tone: Light, satisfying "click"
- Style: Game UI, friendly and responsive
```

**6. ui_level_up.wav**
```
Generate a level up celebration sound effect.
- Duration: 1.0-1.5 seconds
- Type: Achievement fanfare with chimes
- Tone: Ascending, bright "ding-ding-ding-DING!"
- Style: Fantasy game, celebration, rewarding feel
```

### 배경음악

**7. bgm_battle.wav**
```
Generate a battle background music (loopable).
- Duration: 60-120 seconds
- Type: Epic fantasy battle theme
- Instruments: Orchestral strings, brass, percussion, choir
- Mood: Intense, heroic, epic battle
- Tempo: Moderate-fast (120-140 BPM)
- Style: Fantasy game BGM, epic and motivating
- Key: Minor key (A minor or D minor), dramatic
- Must loop seamlessly
```

---

## 📝 대체 생성 방법

### 무료 리소스 사이트
- **Images**: OpenGameArt.org, itch.io (free assets), Kenney.nl
- **Sounds**: Freesound.org, Zapsplat.com, OpenGameArt.org

### AI 생성 도구
- **Images**:
  - DALL-E 3 (위 프롬프트 사용)
  - Midjourney (pixel art 모드)
  - Stable Diffusion (pixel art 모델)
  - Aseprite (픽셀 아트 제작 툴)

- **Sounds**:
  - ElevenLabs Sound Effects
  - Soundraw.io
  - Jsfxr.com (8-bit style)
  - Bfxr.net (게임 효과음)

### 임시 플레이스홀더
현재 코드는 에셋이 없어도 작동합니다:
- 영웅/몬스터: ColoredBox fallback으로 표시
- 사운드: try-catch로 무시
- 배경: 단색 배경

---

## ✅ 구현 완료 상태 (90%)

### 완료된 기능
- ✅ 영웅 시스템 (Hero Entity, HeroData)
  - Tank, Archer, Healer 역할
  - HP/ATK/DEF 스탯
  - 레벨업 시스템
- ✅ 몬스터 시스템 (Monster Entity)
  - 일반/보스 몬스터
  - HP 스케일링
- ✅ 전투 시스템 (BattleGame)
  - 자동 전투 로직
  - 범위 공격 (궁수)
  - 근접 전투 (탱커)
  - 힐 시스템 (힐러)
  - 크리티컬 표시
- ✅ UI 시스템
  - 영웅 관리 패널 (HeroManagementPanel)
  - 스테이지 정보 오버레이 (StageInfoOverlay)
  - 레벨업/고용 버튼
- ✅ 스테이지 매니저 (StageManager)
  - 몬스터 처치 카운트
  - 보스 스폰 로직
  - 스테이지 진행
- ✅ 골드 매니저 (GoldManager)
- ✅ GetIt 의존성 주입

### 남은 작업 (10%)
- ⏳ 에셋 생성 (위 프롬프트 사용)
  - 8개 이미지 에셋
  - 7개 사운드 에셋
- ⏳ 방치 수익 시스템 (오프라인 보상)
- ⏳ 장비 시스템 (선택사항)
- ⏳ 더 많은 영웅 종류 (선택사항)

게임 코어 로직은 90% 완성되었으며, 에셋만 추가하면 바로 플레이 가능합니다!

---

## 🎮 현재 플레이 가능 시나리오

에셋 없이도 현재 작동하는 것:
1. 초기 파티 (기사 + 궁수) 스폰
2. 몬스터 자동 스폰 (2초마다)
3. 영웅들이 자동으로 몬스터 공격
   - 궁수: 원거리 크리티컬 공격
   - 기사: 근접 방어
4. 몬스터 처치 시 골드 획득 (+10골드)
5. 골드로 영웅 레벨업 (50골드)
6. 1000골드로 힐러 고용
7. 힐러가 파티 힐링
8. 10마리 처치 시 보스 스폰
9. 보스 처치 시 보너스 골드 (+50골드)

에셋 추가 후 추가되는 것:
- 실제 캐릭터 비주얼
- 전투 사운드
- 배경 분위기
- 몰입감 향상

---

## 🆕 추가 권장 기능

### 우선순위 1: 방치 수익
- 마지막 로그인 시간 저장
- 오프라인 경과 시간 계산
- 시간당 골드/경험치 계산
- 복귀 시 보상 팝업

### 우선순위 2: 장비 시스템
- 무기/방어구 아이템
- 드롭 시스템
- 장착/강화 UI

### 우선순위 3: 더 많은 영웅
- 마법사 (Mage) - 광역 마법
- 암살자 (Assassin) - 고속 단일 공격
- 버퍼 (Buffer) - 아군 버프

### 우선순위 4: 스테이지 다양화
- 다른 배경의 스테이지
- 스테이지별 특수 몬스터
- 보스 패턴 다양화

---

## 📊 기술 스택

- **Framework**: Flutter + Flame Engine
- **Language**: Dart
- **State Management**: ChangeNotifier (기본)
- **DI**: GetIt
- **Common Modules**: mg_common_game (GoldManager, AudioManager, FloatingTextComponent)

---

## 🐛 알려진 이슈

### 스타일 이슈
- ⚠️ 일부 파일에서 `if` 문에 중괄호 미사용 (curly_braces_in_flow_control_structures)
- ⚠️ 불필요한 밑줄 사용 (unnecessary_underscores)
- ⚠️ withOpacity deprecated (deprecated_member_use)

### 기능 이슈
- ⚠️ 영웅 사망 시 즉시 리스폰 (임시 로직)
- ⚠️ 방치 수익 미구현

이슈들은 게임 플레이에 영향을 주지 않습니다.

---

## 🎯 개발 우선순위

1. **에셋 생성** (필수) - 비주얼 경험 향상
2. **방치 수익 시스템** (권장) - 방치형 게임의 핵심
3. **스타일 이슈 수정** (선택) - 코드 품질 향상
4. **추가 콘텐츠** (선택) - 재미 요소 확장

---

**게임은 현재 플레이 가능 상태이며, 에셋 추가 시 95% 완성도 달성!**

## 🌍 Phase 3: Stage Expansion Assets

### Backgrounds
**9. bg_forest.png**
```
Create a forest battle background (1920x1080px).
- Style: Side-scrolling pixel art
- Subject: Ancient mystical forest
- Details: Tall trees, filtered sunlight, vines, mossy rocks
- Color palette: Dark greens, browns, soft light rays
- Mood: Mysterious, calm but dangerous
```

**10. bg_desert.png**
```
Create a desert battle background (1920x1080px).
- Style: Side-scrolling pixel art
- Subject: Hot sandy desert
- Details: Sand dunes, cacti, bright sun, heat haze
- Color palette: Oranges, yellows, bright blue sky
- Mood: Hot, arid, vast
```

### Monsters
**11. monster_orc.png**
```
Create a pixel art orc sprite (64x64px).
- Style: Side view enemy
- Subject: Orc warrior
- Details: Green skin, muscular, leather armor, crude axe
- Pose: Aggressive, facing left
```

**12. monster_snake.png**
```
Create a pixel art snake sprite (64x64px).
- Style: Side view enemy
- Subject: Giant Cobra
- Details: Purple/Green scales, hood, fangs
- Pose: Coiled and striking, facing left
```

